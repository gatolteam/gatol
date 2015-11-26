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
	 			expect(result["question_sets"]).to eq([])
 			end
 		end

 		context("successful nontrivial GET") do
			before(:each) do
 				@user = FactoryGirl.create(:trainer, id: 1234)
 				request.headers['Authorization'] =  @user.auth_token
 				s1 = FactoryGirl.create(:question_set_varied, trainer_id: 1234)
 				s0 = FactoryGirl.create(:question_set_repeat, question_count: 1, trainer_id: 1234)

 				@s = [s0, s1]
 				FactoryGirl.create(:question_set_repeat, trainer_id: 2233)
 				FactoryGirl.create(:question_set_repeat, trainer_id: 6291)
 				get :index
 				@result = JSON.parse(response.body)
 				@resultSet = @result["question_sets"]
			end

	 			it "only gets QuestionSets belonging to specified User" do
	 				for i in 0..1
						expect(@resultSet[i]["trainer_id"]).to eq(@user.id)
					end
					expect(@resultSet.length).to eq(2)
	 			end

				it "gets each QuestionSet's data" do
					for i in 0..1
						set = @resultSet[i]
						expect(set["id"]).to eq(@s[i].id)
						expect(set["setname"]).to eq(@s[i].setname)
					end
				end

				it "gets all QuestionSet's Questions" do
					expect(@resultSet[1]["questions"].length).to eq(2)
					expect(@resultSet[0]["questions"].length).to eq(1)
				end

				it "gets QuestionSet's Questions: 1st" do
					for i in 0..1
						checkQuestion(@resultSet[i]["questions"][0], @s[i].questions[0])
					end
				end

				it "gets QuestionSet's Questions: 2nd" do
					checkQuestion(@resultSet[1]["questions"][1], @s[1].questions[1])
				end
			end

		context "unsuccessful" do
			it "cannot get due to 'not trainer' error" do
				@user = FactoryGirl.create(:student, id: 333)
	 			request.headers['Authorization'] =  @user.auth_token

	 			get :index
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(401)
	 			expect(result["errors"][0]).to eq('the user is not a trainer')
			end
		end
	end

	describe "GET #show" do
		context "successful" do
			it "gets correct QuestionSet" do
				user = FactoryGirl.create(:trainer, id: 1234)
 				request.headers['Authorization'] =  user.auth_token
 				s1 = FactoryGirl.create(:question_set_varied, trainer_id: 1234, setname: "coolio")
 				s0 = FactoryGirl.create(:question_set_repeat, trainer_id: 1234, setname: "lame-o")
 				get :show, id: s1.id
 				result = JSON.parse(response.body)
 				resultSet = result["question_set"]

 				expect(resultSet).to be_instance_of(Hash)
 				expect(resultSet).not_to be_instance_of(Array)
 				expect(resultSet["setname"]).to eq(s1.setname)
 				resultQ = resultSet["questions"]
 				expect(resultQ.length).to eq(2)
 				for i in 0..1
	 				checkQuestion(resultQ[i], s1.questions[i])
 				end
			end
		end
		context "unsuccessful" do
			it "cannot get due to 'not trainer' error" do
				user = FactoryGirl.create(:student, id: 333)
	 			request.headers['Authorization'] =  user.auth_token

	 			get :show, id: 5
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(401)
	 			expect(result["errors"][0]).to eq('the user is not a trainer')
			end

			it "cannot get due to 'no access' error" do
				user = FactoryGirl.create(:trainer, id: 0020)
	 			request.headers['Authorization'] =  user.auth_token
	 			f = FactoryGirl.create(:question_set_repeat, trainer_id: 999)

	 			get :show, id: f.id

	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(401)
	 			expect(result["errors"][0]).to eq('trainer does not have access to this question set')
			end

			it "cannot get due to 'not exist' error" do
				user = FactoryGirl.create(:trainer, id: 0020)
	 			request.headers['Authorization'] =  user.auth_token

	 			get :show, id: 5
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(400)
	 			expect(result["errors"][0]).to eq('question set does not exist')

			end
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
				expect(@response.status).to eq(200)
			end

			it "saves new set" do
				resultSet = @result["question_set"]
				set = QuestionSet.find(resultSet["id"])
				expect(resultSet["trainer_id"]).to eq(@user.id)
				expect(resultSet["setname"]).to eq(set.setname)
				expect(resultSet["questions"].length).to eq(3)
			end

		end

		context "unsuccessful" do
			it "cannot import due to 'not trainer' error" do
				@user = FactoryGirl.create(:student, id: 333)
	 			request.headers['Authorization'] =  @user.auth_token

	 			delete :import, file: fixture_file_upload('files/demo1.csv', 'text/csv')
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(401)
	 			expect(result["errors"][0]).to eq('the user is not a trainer')
			end

			it "does not create Question Sets for bad CSV" do
				@user = FactoryGirl.create(:trainer, id: 333)
	 			request.headers['Authorization'] =  @user.auth_token

	 			delete :import, file: fixture_file_upload('files/bad_header_long.csv', 'text/csv')
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(400)
	 			expect(result["errors"][0]).to eq('Invalid CSV: bad header length 10, CSV must have exactly 9 columns')
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
	 			expect(response.status).to eq(200)
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
	 			expect(response.status).to eq(401)
	 			expect(result["errors"][0]).to eq('trainer does not have access to this question set')
			end

			it "cannot delete due to 'not exist' error" do
				@user = FactoryGirl.create(:trainer, id: 0020)
	 			request.headers['Authorization'] =  @user.auth_token

	 			delete :destroy, id: 6667
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(400)
	 			expect(result["errors"][0]).to eq('question set does not exist')

			end

			it "cannot delete due to 'not trainer' error" do
				@user = FactoryGirl.create(:student, id: 333)
	 			request.headers['Authorization'] =  @user.auth_token

	 			delete :destroy, id: 2
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(401)
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