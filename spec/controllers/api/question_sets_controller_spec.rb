require 'rails_helper'
require 'json'

RSpec.describe Api::QuestionSetsController, type: :controller do

 	describe "GET #index" do
 		context("successful trivial GET") do
 			it "gets no sets (user has none)" do
 				user = FactoryGirl.create(:trainer, id: 0020)
	 			request.headers['Authorization'] =  user.auth_token
	 			FactoryGirl.create(:question_set_repeat, trainer_id: 555)
	 			get :index
	 			result = JSON.parse(response.body)
	 			expect(result["question_sets"]).to eq("[]")
 			end
 		end

 		context("successful nontrivial GET") do
			before(:each) do
 				@user = FactoryGirl.create(:trainer, id: 1234)
 				request.headers['Authorization'] =  @user.auth_token
 				@sampleSet = FactoryGirl.create(:question_set_varied)
 				FactoryGirl.create(:question_set_repeat, trainer_id: 2233)
 				FactoryGirl.create(:question_set_repeat, trainer_id: 6291)
 				get :index
 				@result = JSON.parse(response.body)
 				@resultSet = JSON.parse(@result["question_sets"])
			end

	 			it "only gets QuestionSets belonging to specified User" do
					#expect(@result["id"]).to eq(@user.id)
					expect(@resultSet.length).to eq(1)
	 			end

				it "gets each QuestionSet's data" do
					set = @resultSet[0]
					expect(set["id"]).to eq(@sampleSet.id)
					expect(set["setname"]).to eq(@sampleSet.setname)
				end

				it "gets all QuestionSet's Questions" do
					expect(@resultSet[0]["questions"].length).to eq(2)
				end

				it "gets QuestionSet's Questions: 1st" do
					checkQuestion(@resultSet[0]["questions"][0], @sampleSet.questions[0])
				end

				it "gets QuestionSet's Questions: 2nd" do
					checkQuestion(@resultSet[0]["questions"][1], @sampleSet.questions[1])
				end
			end

		context "unsuccessful: not trainer" do
			pending
		end
	end

	describe "GET #show" do
		context "successful" do
			pending
		end
		context "unsuccessful: not trainer" do
			pending
		end
	end

	describe "POST #import" do
		context "successful" do
			before(:each) do
				@user = FactoryGirl.create(:trainer, id: 8888)
	 			request.headers['Authorization'] =  @user.auth_token

	 			post :import, file: fixture_file_upload('files/demo1.csv', 'text/csv')
	 			@result = JSON.parse(response.body)
			end

			it "has success status" do
				expect(@result["status"]).to eq(200)
			end

			it "saves new set" do
				resultSet = JSON.parse(@result["question_set"])
				set = QuestionSet.find(resultSet["id"])
				expect(resultSet["trainer_id"]).to eq(@user.id)
				expect(resultSet["setname"]).to eq(set.setname)
				expect(resultSet["questions"].length).to eq(3)
			end

		end
	end


	describe "DELETE #destroy" do
		context "successful" do
			it "deletes question set" do
				user = FactoryGirl.create(:trainer, id: 0020)
	 			request.headers['Authorization'] =  user.auth_token
	 			f = FactoryGirl.create(:question_set_repeat, trainer_id: 0020)

	 			delete :destroy, id: f.id

	 			result = JSON.parse(response.body)
	 			expect(result["status"]).to eq(200)
	 			expect(result.has_key?("errors")).to be_falsey
	 			expect(QuestionSet.find_by_id(f.id)).to be_nil
			end
		end
		context "unsuccessful" do
			it "cannot delete due to 'no access' error" do
				@user = FactoryGirl.create(:trainer, id: 0020)
	 			request.headers['Authorization'] =  @user.auth_token
	 			@f = FactoryGirl.create(:question_set_repeat, trainer_id: 1234)

	 			delete :destroy, id: @f.id

	 			result = JSON.parse(response.body)
	 			expect(result["status"]).to eq(401)
	 			expect(result["errors"][0]).to eq('trainer does not have access to this question set')
			end

			it "cannot delete due to 'not exist' error" do
				@user = FactoryGirl.create(:trainer, id: 0020)
	 			request.headers['Authorization'] =  @user.auth_token

	 			delete :destroy, id: 6667
	 			result = JSON.parse(response.body)
	 			expect(result["status"]).to eq(400)
	 			expect(result["errors"][0]).to eq('question set does not exist')

			end

			it "cannot delete due to 'not trainer' error" do
				@user = FactoryGirl.create(:student, id: 333)
	 			request.headers['Authorization'] =  @user.auth_token

	 			delete :destroy, id: 2
	 			result = JSON.parse(response.body)
	 			expect(result["status"]).to eq(401)
	 			expect(result["errors"][0]).to eq('the user is not a trainer')
			end


		end
	end

	def checkQuestion(actual, expected)
		expect(actual["questionIdx"]).to eq(expected.questionIdx)
		expect(actual["question"]).to eq(expected.question)
		expect(actual["answerCorrect"]).to eq(expected.answerCorrect)
		expect(actual["answerWrong1"]).to eq(expected.answerWrong1)
		expect(actual["answerWrong2"]).to eq(expected.answerWrong2)
		expect(actual["answerWrong3"]).to eq(expected.answerWrong3)
		expect(actual["answerWrong4"]).to eq(expected.answerWrong4)
		expect(actual["answerWrong5"]).to eq(expected.answerWrong5)
		expect(actual["answerWrong6"]).to eq(expected.answerWrong6)
		expect(actual["answerWrong7"]).to eq(expected.answerWrong7)
	end

end