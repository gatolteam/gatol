require 'rails_helper'

RSpec.describe Api::GamesController, type: :controller do

	#view all games created by trainer
	describe "GET #index" do
		context "successful trainer" do
			it "gets all of trainer's games" do
				user = FactoryGirl.create(:trainer, id: 1234)
	 			request.headers['Authorization'] =  user.auth_token
	 			g = []
	 			g << FactoryGirl.create(:game_b, trainer_id: user.id)
	 			g << FactoryGirl.create(:game_a, trainer_id: user.id)

	 			get :index
	 			result = JSON.parse(response.body)
	 			resultGames = result["games"]

	 			expect(resultGames.length).to eq(g.length)
	 			checkTrainerGame(resultGames[0], g[1])
	 			checkTrainerGame(resultGames[1], g[0])
			end
		end

		context "successful student" do
			it "gets all of student's games" do
				g = FactoryGirl.create(:game_b)
				user = FactoryGirl.create(:student, id: 665, email: "hello@me.com")
	 			request.headers['Authorization'] =  user.auth_token
	 			e = FactoryGirl.create(:game_enrollment, game_id: g.id, student_email: user.email)
	 			e.game = g

	 			get :index
	 			result = JSON.parse(response.body)
	 			resultGames = result["games"]
	 			expect(response.status).to eq(200)
	 			expect(resultGames.length).to eq(1)
	 			checkStudentGame(resultGames[0], g)
			end
		end
	end

	describe "GET #show" do
		context "successful" do
			it "gets specific game for trainer" do
				user = FactoryGirl.create(:trainer, id: 1234)
	 			request.headers['Authorization'] =  user.auth_token
	 			a = FactoryGirl.create(:game_a, trainer_id: user.id)
	 			FactoryGirl.create(:game_b, trainer_id: user.id)

	 			get :show, id: a.id
	 			result = JSON.parse(response.body)
	 			resultGame = result["game"]
	 			#puts resultGame
	 			expect(resultGame).to be_instance_of(Hash)
 				expect(resultGame).not_to be_instance_of(Array)
 				checkTrainerGame(resultGame, a)
			end

			it "gets specific game for student" do
				g = FactoryGirl.create(:game_b)
				user = FactoryGirl.create(:student, id: 665, email: "hello@me.com")
	 			request.headers['Authorization'] =  user.auth_token
	 			e = FactoryGirl.create(:game_enrollment, game_id: g.id, student_email: user.email)
	 			e.game = g

	 			get :show, id: g.id
	 			result = JSON.parse(response.body)
	 			resultGame = result["game"]
	 			#puts resultGame
	 			expect(response.status).to eq(200)
	 			expect(resultGame).to be_instance_of(Hash)
 				expect(resultGame).not_to be_instance_of(Array)
	 			checkStudentGame(resultGame, g)
	 			#expect(response.status).to eq(401)
	 			##expect(result["errors"][0]).to eq('user is not a trainer')
			end

		end
		context "unsuccessful" do

			it "cannot get game due to 'no access' error (student)" do
				user = FactoryGirl.create(:student, id: 333)
	 			request.headers['Authorization'] =  user.auth_token
	 			f = FactoryGirl.create(:game_b, trainer_id: 777)

	 			get :show, id: f.id
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(401)
	 			expect(result["errors"][0]).to eq('user does not have access to this game')
			end

			it "cannot get game due to 'no access' error (trainer)" do
				user = FactoryGirl.create(:trainer, id: 333)
	 			request.headers['Authorization'] =  user.auth_token
	 			f = FactoryGirl.create(:game_b, trainer_id: 777)

	 			get :show, id: f.id
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(401)
	 			expect(result["errors"][0]).to eq('trainer does not have access to this game')
			end

			it "cannot get game due to 'not exist' error" do
				user = FactoryGirl.create(:trainer, id: 0020)
	 			request.headers['Authorization'] =  user.auth_token

	 			get :show, id: 5
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(400)
	 			expect(result["errors"][0]).to eq('game does not exist')
			end
		end
	end

	#create game
	describe "POST #create" do
		context "successful" do
			before(:each) do
				@temp = FactoryGirl.create(:game_template_a)
				@set = FactoryGirl.create(:question_set_varied)
			end
			it "creates new game" do
				user = FactoryGirl.create(:trainer, id: 0020)
	 			request.headers['Authorization'] =  user.auth_token
	 			g =  { trainer_id: user.id, 
	 				   question_set_id: @set.id, 
	 				   game_template_id: @temp.id, 
	 				   name: "Blubber", 
	 				   description: "what"}
	 				   
	 			post :create, game: g

	 			expect(response.status).to eq(200)
	 			createdGame = Game.find_by name: g[:name], trainer_id: user.id
	 			expect(createdGame["name"]).to eq(g[:name])
	 			expect(createdGame["description"]).to eq(g[:description])
	 			expect(createdGame["name"]).to eq(g[:name])
	 			expect(createdGame["game_template_id"]).to eq(g[:game_template_id])
	 			expect(createdGame["question_set_id"]).to eq(g[:question_set_id])
	 			expect(createdGame["trainer_id"]).to eq(g[:trainer_id])
			end
		end

		context "unsuccessful" do
			before(:each) do
				@temp = FactoryGirl.create(:game_template_a)
				@set = FactoryGirl.create(:question_set_varied)
			end
			it "cannot create due to 'not trainer' error" do
				user = FactoryGirl.create(:student, id: 6679)
	 			request.headers['Authorization'] =  user.auth_token
	 			g =  { trainer_id: user.id, question_set_id: @set.id, game_template_id: @temp.id, name: "Blubber", description: "what"}

	 			post :create, game: g

	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(401)
	 			expect(result["errors"][0]).to eq('user is not a trainer')
			end

			it "cannot save due to missing attribute" do
				user = FactoryGirl.create(:trainer, id: 6679)
	 			request.headers['Authorization'] =  user.auth_token
	 			g =  { trainer_id: user.id, question_set_id: @set.id, game_template_id: @temp.id, name: "Blubber"}

	 			post :create, game: g
	 			
	 			result = JSON.parse(response.body)
	 			expect(response.status).to eq(401)
	 			expect(result["errors"]).to eq(["Description can't be blank", 
	 				"Description must have at least 1 characters"])
			end
		end
	end

	def checkTrainerGame(act, exp)
		expect(act["name"]).to eq(exp.name)
		expect(act["description"]).to eq(exp.description)
	 	expect(act["trainer_id"]).to eq(exp.trainer_id)
	 	expect(act["game_template_id"]).to eq(exp.game_template_id)
	end

	def checkStudentGame(act, exp)
		expect(act["name"]).to eq(exp.name)
		expect(act["description"]).to eq(exp.description)
		expect(act["game_template_id"]).to eq(exp.game_template_id)
		expect(act.has_key?("trainer_id")).to be_falsey
	end

end
