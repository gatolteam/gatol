require 'rails_helper'

RSpec.describe Api::GameInstancesController, type: :controller do

	describe "GET #index" do
		#get_stats_all_trainer
		context "successful by trainer" do
			it "" do
			end
		end
		context "unsuccessful by trainer" do
			pending
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
		end
	end

	describe "GET #show" do
		context "successul by trainer" do
			pending
		end
	end

	describe "POST #create" do
		pending
	end

	describe "PUT #update" do
		it "only allows score updates for student owner of game" do
			
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
