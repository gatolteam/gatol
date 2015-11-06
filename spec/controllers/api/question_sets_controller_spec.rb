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
					question0 = @resultSet[0]["questions"][0]
					expect(question0["questionIdx"]).to eq(@sampleSet.questions[0].questionIdx)
					expect(question0["question"]).to eq(@sampleSet.questions[0].question)
					expect(question0["answerCorrect"]).to eq(@sampleSet.questions[0].answerCorrect)
					expect(question0["answerWrong1"]).to eq(@sampleSet.questions[0].answerWrong1)
					expect(question0["answerWrong2"]).to eq(@sampleSet.questions[0].answerWrong2)
					expect(question0["answerWrong3"]).to eq(@sampleSet.questions[0].answerWrong3)
					expect(question0["answerWrong4"]).to eq(@sampleSet.questions[0].answerWrong4)
					expect(question0["answerWrong5"]).to eq(@sampleSet.questions[0].answerWrong5)
					expect(question0["answerWrong6"]).to eq(@sampleSet.questions[0].answerWrong6)
					expect(question0["answerWrong7"]).to eq(@sampleSet.questions[0].answerWrong7)
				end

				it "gets QuestionSet's Questions: 2nd" do
					question1 = @resultSet[0]["questions"][1]
					expect(question1["questionIdx"]).to eq(@sampleSet.questions[1].questionIdx)
					expect(question1["question"]).to eq(@sampleSet.questions[1].question)
					expect(question1["answerCorrect"]).to eq(@sampleSet.questions[1].answerCorrect)
					expect(question1["answerWrong1"]).to eq(@sampleSet.questions[1].answerWrong1)
					expect(question1["answerWrong2"]).to eq(@sampleSet.questions[1].answerWrong2)
					expect(question1["answerWrong3"]).to eq(@sampleSet.questions[1].answerWrong3)
					expect(question1["answerWrong4"]).to eq(@sampleSet.questions[1].answerWrong4)
					expect(question1["answerWrong5"]).to eq(@sampleSet.questions[1].answerWrong5)
					expect(question1["answerWrong6"]).to eq(@sampleSet.questions[1].answerWrong6)
					expect(question1["answerWrong7"]).to eq(@sampleSet.questions[1].answerWrong7)
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

end