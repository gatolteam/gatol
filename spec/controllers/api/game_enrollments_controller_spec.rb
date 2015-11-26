require 'rails_helper'

RSpec.describe Api::GameEnrollmentsController, type: :controller do

	describe "#create" do
		it "adds students to the game_enrollment" do
			user = FactoryGirl.create(:trainer, id: 1234)
			user2 = FactoryGirl.create(:student, id: 12)
			request.headers['Authorization'] = user.auth_token
			game = FactoryGirl.create(:game_a, trainer_id: user.id)

			enrollment = { game_id: game.id, student_email: user2.email }
	 		post :create, game_enrollment: enrollment

	 		expect(response.status).to eq(200)
	 		createdEnrollment = GameEnrollment.find_by student_email: user2.email
	 		expect(createdEnrollment["game_id"]).to eq(game.id)
		end


		it "401 error when students wants to create" do
			user = FactoryGirl.create(:trainer, id: 1234)
			user2 = FactoryGirl.create(:student, id: 12)
			request.headers['Authorization'] = user2.auth_token
			game = FactoryGirl.create(:game_a, trainer_id: user.id)

			enrollment = { game_id: game.id, student_email: user2.email }
	 		post :create, game_enrollment: enrollment

	 		expect(response.status).to eq(401)
	 	end


	 	it "401 error when game does not exist" do
	 		user = FactoryGirl.create(:trainer, id: 1234)
			user2 = FactoryGirl.create(:student, id: 12)
			request.headers['Authorization'] = user.auth_token

			enrollment = { game_id: 1234567, student_email: user.email }
	 		post :create, game_enrollment: enrollment

	 		expect(response.status).to eq(401)
	 	end
	end




	describe "#show" do
		before(:each) do
			@user = FactoryGirl.create(:trainer, id: 1234)
			@user2 = FactoryGirl.create(:student, id: 12)
			@user3 = FactoryGirl.create(:trainer, id: 1235)
			@game = FactoryGirl.create(:game_a, trainer_id: @user.id)
			@enrollment = FactoryGirl.create(:game_enrollment,
				trainer_id: @user.id,
				game_id: @game.id,
				student_email: @user2.email,
				registered: true)
		end


		it "view enrollment of a specific games the trainer owns" do
			request.headers['Authorization'] = @user.auth_token
			get :show, id: @game.id
			result = JSON.parse(response.body)
			enroll_list = result["game_enrollments"]

			expect(response.status).to eq(200)
			expect(enroll_list.length).to eq(1)
			expect(enroll_list[0]["student_email"]).to eq(@user2.email)
		end

		it "401 error when a student attempts to view" do
			request.headers['Authorization'] = @user2.auth_token
			get :show, id: @game.id
			result = JSON.parse(response.body)
			enroll_list = result["game_enrollments"]

			expect(response.status).to eq(401)
		end

		it "401 error an unauthorized trainer attempts to view" do
			request.headers['Authorization'] = @user3.auth_token
			get :show, id: @game.id
			result = JSON.parse(response.body)
			enroll_list = result["game_enrollments"]

			expect(response.status).to eq(401)
		end

	end





	describe "#index" do
		before(:each) do
			@user = FactoryGirl.create(:trainer, id: 1234)
			@user2 = FactoryGirl.create(:student, id: 12)
			@game = FactoryGirl.create(:game_a, trainer_id: @user.id)
			@enrollment = FactoryGirl.create(:game_enrollment,
				trainer_id: @user.id,
				game_id: @game.id,
				student_email: @user2.email,
				registered: true)
		end



		it "shows enrollment of all games the trainer owns" do
			request.headers['Authorization'] = @user.auth_token
			get :index
			result = JSON.parse(response.body)
			enroll_list = result["game_enrollments"]

			expect(response.status).to eq(200)
			expect(enroll_list.length).to eq(1)
			expect(enroll_list[0]["student_email"]).to eq(@user2.email)
		end



		it "shows enrollment of all games the trainer owns" do
			request.headers['Authorization'] = @user.auth_token
			get :index
			result = JSON.parse(response.body)
			enroll_list = result["game_enrollments"]

			expect(response.status).to eq(200)
			expect(enroll_list.length).to eq(1)
			expect(enroll_list[0]["student_email"]).to eq(@user2.email)
		end

	end






	describe "#delete" do
		before(:each) do
			@user = FactoryGirl.create(:trainer, id: 1234)
			@user2 = FactoryGirl.create(:student, id: 12)
			@user3 = FactoryGirl.create(:trainer, id: 1235)
			@game = FactoryGirl.create(:game_a, trainer_id: @user.id)
			@enrollment = FactoryGirl.create(:game_enrollment,
				trainer_id: @user.id,
				game_id: @game.id,
				student_email: @user2.email,
				registered: true)
		end

		it "destroys enrollment" do
			request.headers['Authorization'] = @user.auth_token
			delete :destroy, id: @enrollment.id

			expect(response.status).to eq(204)

		end


		it "401 when an unauthorized trainer attempts to delete" do
			request.headers['Authorization'] = @user3.auth_token
			delete :destroy, id: @enrollment.id

			expect(response.status).to eq(401)
		end


		it "401 when a student attempts to delete" do
			request.headers['Authorization'] = @user2.auth_token
			delete :destroy, id: @enrollment.id

			expect(response.status).to eq(401)
		end



		it "400 when the enrollment is not found" do
			request.headers['Authorization'] = @user.auth_token
			delete :destroy, id: 123456

			expect(response.status).to eq(400)
		end
	end

end
