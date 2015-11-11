require 'rails_helper'

RSpec.describe Api::GamesController, type: :controller do

	#view all games created by trainer
	describe "GET #index" do
		context "successful" do
			it "" do
				user = FactoryGirl.create(:trainer, id: 1234)
	 			request.headers['Authorization'] =  user.auth_token
	 			g = []
	 			g << FactoryGirl.create(:game_b, trainer_id: user.id)
	 			g << FactoryGirl.create(:game_a, trainer_id: user.id)

	 			get :index
	 			result = JSON.parse(response.body)
	 			resultGames = result["games"]

	 			expect(resultGames.length).to eq(g.length)
	 			for i in 1..0
	 				checkGame(resultGames[i], g[i])
	 			end
			end
		end

		context "unsuccessful" do
			it "cannot get games due to 'not trainer' error" do
				user = FactoryGirl.create(:student, id: 665)
	 			request.headers['Authorization'] =  user.auth_token
	 			get :index
	 			result = JSON.parse(response.body)
	 			expect(result["status"]).to eq(401)
	 			expect(result["errors"][0]).to eq('user is not a trainer')
			end
		end
	end

	describe "GET #show" do
		context "successful" do
			it "gets specific game" do
				user = FactoryGirl.create(:trainer, id: 1234)
	 			request.headers['Authorization'] =  user.auth_token
	 			a = FactoryGirl.create(:game_a, trainer_id: 1234)
	 			FactoryGirl.create(:game_b, trainer_id: 1234)

	 			get :show, id: a.id
	 			result = JSON.parse(response.body)
	 			resultGame = result["game"]
	 			expect(resultGame).to be_instance_of(Hash)
 				expect(resultGame).not_to be_instance_of(Array)
 				checkGame(resultGame, a)
			end
		end
		context "unsuccessful" do
			it "cannot get game due to 'not trainer' error" do
				user = FactoryGirl.create(:student, id: 333)
	 			request.headers['Authorization'] =  user.auth_token

	 			get :show, id: 5
	 			result = JSON.parse(response.body)
	 			expect(result["status"]).to eq(401)
	 			expect(result["errors"][0]).to eq('user is not a trainer')
			end

			it "cannot get game due to 'no access' error" do
				user = FactoryGirl.create(:trainer, id: 333)
	 			request.headers['Authorization'] =  user.auth_token
	 			f = FactoryGirl.create(:game_b, trainer_id: 777)

	 			get :show, id: f.id
	 			result = JSON.parse(response.body)
	 			expect(result["status"]).to eq(401)
	 			expect(result["errors"][0]).to eq('trainer does not have access to this game')
			end

			it "cannot get game due to 'not exist' error" do
				user = FactoryGirl.create(:trainer, id: 0020)
	 			request.headers['Authorization'] =  user.auth_token

	 			get :show, id: 5
	 			result = JSON.parse(response.body)
	 			expect(result["status"]).to eq(400)
	 			expect(result["errors"][0]).to eq('game does not exist')
			end
		end
	end

	#create game
	describe "POST #create" do
	end

	#enroll players in game
	describe "POST #enroll" do
	end


	def checkGame(act, exp)
		expect(act["name"]).to eq(exp.name)
		expect(act["description"]).to eq(exp.description)
	 	expect(act["trainer_id"]).to eq(exp.trainer_id)
	 	expect(act["game_template_id"]).to eq(exp.game_template_id)
	end

end
