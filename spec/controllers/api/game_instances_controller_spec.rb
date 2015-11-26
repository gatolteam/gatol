require 'rails_helper'

RSpec.describe Api::GameInstancesController, type: :controller do

	describe "GET #index" do
		#get_stats_all_trainer
		context "successful by trainer" do
			it "gets summaries of all games" do
				user = FactoryGirl.create(:trainer)
	 			request.headers['Authorization'] =  user.auth_token
	 			g1 = FactoryGirl.create(:game, trainer_id: user.id)
	 			g2 = FactoryGirl.create(:game, trainer_id: user.id)
	 			d = FactoryGirl.create(:game_instance_inactive, game_id: g1.id, score: 20, student_id: 1)
				e = FactoryGirl.create(:game_instance_inactive, game_id: g2.id, score: 30, student_id: 1)
				f = FactoryGirl.create(:game_instance_inactive, game_id: g2.id, score: 40, student_id: 2)

	 			get :index
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(200)
	 			expect(result["ranking"].length).to eq(2)
	 			expect(result["ranking"]["#{g1.id}"].length).to eq(1)
	 			expect(result["ranking"]["#{g2.id}"].length).to eq(2)
			end

			it "only gets summaries of games belonging to trainer" do
				user = FactoryGirl.create(:trainer)
	 			request.headers['Authorization'] =  user.auth_token
	 			g2 = FactoryGirl.create(:game, trainer_id: user.id+1)

	 			get :index
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(200)
	 			expect(result["ranking"].length).to eq(0)
			end
		end

		#get_stats_all_student
		context "successful by student" do
			it "gets all scores of all games" do
				user = FactoryGirl.create(:student, id:12)
	 			request.headers['Authorization'] =  user.auth_token
	 			e = FactoryGirl.create(:game_instance_inactive, game_id: 55, score: 20, student_id: user.id)
				f = FactoryGirl.create(:game_instance_inactive, game_id: 56, score: 30, student_id: user.id)

	 			get :index
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(200)
	 			expect(result["history"].length).to eq(2)
	 			checkGameInstance(result["history"][0], f)
	 			checkGameInstance(result["history"][1], e)
			end

			it "only gets all scores of student" do
				user = FactoryGirl.create(:student, id:12)
	 			request.headers['Authorization'] =  user.auth_token
	 			f = FactoryGirl.create(:game_instance_inactive, game_id: 56, score: 30, student_id: 13)

	 			get :index
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(200)
	 			expect(result["history"].length).to eq(0)
			end

		end
	end

	describe "GET #show" do
		context "successul by student" do
			it "gets the specific game instance" do
				user = FactoryGirl.create(:student, id:12)
	 			request.headers['Authorization'] =  user.auth_token
	 			e = FactoryGirl.create(:game_instance_inactive, game_id: 55, score: 20, student_id: user.id)
				
				get :show, id: e.id
				result = JSON.parse(response.body)
	 			expect(response.status).to eq(200)
	 			checkGameInstance(result["game_instance"], e)
			end
		end

		context "unsuccessful by student" do
			it "cannot get due to 'no access' error" do
				user = FactoryGirl.create(:student, id:12)
	 			request.headers['Authorization'] =  user.auth_token
	 			e = FactoryGirl.create(:game_instance_inactive, game_id: 55, score: 20, student_id: 13)
				
				get :show, id: e.id
				result = JSON.parse(response.body)
	 			expect(response.status).to eq(401)
	 			expect(result["errors"][0]).to eq('user does not have access to this game instance')
			end

			it "cannot get due to 'not exist' error" do
				user = FactoryGirl.create(:student, id:12)
	 			request.headers['Authorization'] =  user.auth_token
				
				get :show, id: 4
				result = JSON.parse(response.body)
	 			expect(response.status).to eq(400)
	 			expect(result["errors"][0]).to eq('game instance does not exist')
			end
		end

		context "successful by trainer" do
			it "gets game instance if trainer is owner of its game" do
				user = FactoryGirl.create(:trainer)
	 			request.headers['Authorization'] =  user.auth_token
	 			game = FactoryGirl.create(:game, trainer_id: user.id)
	 			e = FactoryGirl.create(:game_instance_inactive, game_id: game.id, score: 20, student_id: 1)
				
				get :show, id: e.id
				result = JSON.parse(response.body)
	 			expect(response.status).to eq(200)
	 			checkGameInstance(result["game_instance"], e)
	 		end
		end

		context "unsuccessful by trainer" do
			it "cannot get due to 'no access' error" do
				user = FactoryGirl.create(:trainer)
	 			request.headers['Authorization'] =  user.auth_token
	 			game = FactoryGirl.create(:game, trainer_id: user.id+1)
	 			e = FactoryGirl.create(:game_instance_inactive, game_id: game.id, score: 20, student_id: 1)
				
				get :show, id: e.id
				result = JSON.parse(response.body)
	 			expect(response.status).to eq(401)
	 			expect(result["errors"][0]).to eq('user does not have access to this game instance')
			end
		end
	end

	describe "POST #create" do
		it "cannot get due to 'not exist' error" do
			user = FactoryGirl.create(:student)
 			request.headers['Authorization'] =  user.auth_token
				
			post :create, game_id: 100
			result = JSON.parse(response.body)
 			expect(response.status).to eq(400)
 			expect(result["errors"][0]).to eq('game does not exist for this game_id, cannot create instance')
		end

		context "trainer" do
			it "gets game information" do
				user = FactoryGirl.create(:trainer)
	 			request.headers['Authorization'] =  user.auth_token
	 			game = FactoryGirl.create(:game, trainer_id: user.id)

	 			post :create, game_id: game.id
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(200)
	 			expect(result["game_instance_id"]).to eq(0)
	 			expect(result["game_description"]).to eq(game.description)
	 			expect(result["question_set_id"]).to eq(game.question_set_id)
	 			expect(result["template_id"]).to eq(game.game_template_id)
			end
		end

		context "student" do
			before(:each) do
				user = FactoryGirl.create(:student)
 				request.headers['Authorization'] =  user.auth_token
 				@game = FactoryGirl.create(:game)
			end
			it "creates new game instance" do
				post :create, game_id: @game.id
				result = JSON.parse(response.body)
	 			expect(result["game_description"]).to eq(@game.description)
	 			expect(result["question_set_id"]).to eq(@game.question_set_id)
	 			expect(result["template_id"]).to eq(@game.game_template_id)
			end

			it "handles save error" do
				expect_any_instance_of(GameInstance).to receive(:save!).and_return(false)
				
				post :create, game_id: @game.id
				result = JSON.parse(response.body)
				expect(response.status).to eq(400)
 				expect(result["errors"][0]).to eq('game instance could not be created')
			end

			it "handles other error" do
				msg = "oops"
				expect_any_instance_of(GameInstance).to receive(:save!).and_raise(msg)

				post :create, game_id: @game.id
				result = JSON.parse(response.body)
				expect(response.status).to eq(400)
 				expect(result["errors"][0]).to eq(msg)
			end

		end
	end

	describe "PUT #update" do
		it "returns empty success response for trainer" do
			user = FactoryGirl.create(:trainer)
	 		request.headers['Authorization'] =  user.auth_token

	 		put :update, id: 0

	 		expect(JSON.parse(response.body)).to be_empty
			expect(response.status).to eq(200)
		end

		it "updates score for student owner of game" do
			user = FactoryGirl.create(:student)
	 		request.headers['Authorization'] =  user.auth_token
	 		inst = FactoryGirl.create(:game_instance, student_id: user.id)

	 		put :update, id: inst.id, score: 100, lastQuestion: 1

	 		expect(JSON.parse(response.body)).to be_empty
			expect(response.status).to eq(200)
  		end

  		it "handles update errors" do
			user = FactoryGirl.create(:student)
	 		request.headers['Authorization'] =  user.auth_token
	 		inst = FactoryGirl.create(:game_instance, lastQuestion: 2, student_id: user.id)

	 		put :update, id: inst.id, score: 100, lastQuestion: 1

	 		result = JSON.parse(response.body)
			expect(response.status).to eq(400)
			expect(result["errors"][0]).to eq('update could not be completed')
  		end

  		it "cannot update due to 'not exist' error" do
  			user = FactoryGirl.create(:student)
	 		request.headers['Authorization'] =  user.auth_token

	 		put :update, id: 3, score: 100, lastQuestion: 1

	 		result = JSON.parse(response.body)
			expect(response.status).to eq(400)
			expect(result["errors"][0]).to eq('game instance does not exist')
  		end

  		it "cannot update due to 'no access' error" do
  			user = FactoryGirl.create(:student)
	 		request.headers['Authorization'] =  user.auth_token
	 		inst = FactoryGirl.create(:game_instance, lastQuestion: 2, student_id: user.id+1)

	 		put :update, id: inst.id, score: 100, lastQuestion: 1

	 		result = JSON.parse(response.body)
			expect(response.status).to eq(401)
			expect(result["errors"][0]).to eq('user does not have access to this game instance')
  		end


	end

	describe "GET #get_active" do
		pending
	end

	describe "GET #get_stats_game" do
		pending
	end

	describe "GET #get_stats_player" do
		pending
	end

	describe "GET #get_leaderboard" do
		before(:each) do
			@t = FactoryGirl.create(:trainer)
  			@g = []
			@g << FactoryGirl.create(:game, trainer_id: @t.id)
			@g << FactoryGirl.create(:game, trainer_id: @t.id)

			@sids = []
			@sids << FactoryGirl.create(:student)
			@sids << FactoryGirl.create(:student)
			a = createInstances(2, 4, @sids, @g[0].id)
			a = createInstances(2, 4, @sids, @g[1].id)
 		end


		it "gets the top 10 (student)" do
			@user = FactoryGirl.create(:student)
 			request.headers['Authorization'] =  @user.auth_token
 			game = @g[0].id

			get :get_leaderboard, game_id: game

			result = JSON.parse(response.body)
			#puts result
			resultRank = result["ranking"]
			
			expect(response.status).to eq(200)
			expect(resultRank.length).to eq(4)
			expect(resultRank[0].has_key?('id')).to be_falsey
			expect(resultRank[0].has_key?('student_id')).to be_falsey
			expect(resultRank[0].has_key?('score')).to be true
			expect(resultRank[0].has_key?('email')).to be true
			
		end

		it "gets the top 10 (trainer)" do
			@user = FactoryGirl.create(:student)
 			request.headers['Authorization'] =  @user.auth_token
 			game = @g[0].id

			get :get_leaderboard, game_id: game

			result = JSON.parse(response.body)
			resultRank = result["ranking"]
			
			expect(response.status).to eq(200)
			
		end
	end

def createInstances(bad, total, sids, gid)
	a = []
	for i in 1..bad
		x = FactoryGirl.create(:game_instance_inactive, score: i, student_id: sids.sample.id, game_id: gid)
		a << x
	end

	# the latter part of the array
	for i in bad+1..total
		x =  FactoryGirl.create(:game_instance_inactive, score: i, student_id: sids.sample.id, game_id: gid)
		a << x
	end
	return a
end


def checkGameInstance(act, exp)
	expect(act["id"]).to eq(exp.id)
	expect(act["game_id"]).to eq(exp.game_id)
	expect(act["score"]).to eq(exp.score)
	expect(act["lastQuestion"]).to eq(exp.lastQuestion)
end

end
