require 'rails_helper'

RSpec.describe Api::GameTemplatesController, type: :controller do

	# View Game Templates
	describe "GET #index" do
		context "successful" do
			before(:each) do
				@user = FactoryGirl.create(:trainer, id: 1234)
	 			request.headers['Authorization'] =  @user.auth_token
	 			@t = []
	 			@t << FactoryGirl.create(:game_template_a)
	 			@t << FactoryGirl.create(:game_template_b)

	 			get :index
	 			result = JSON.parse(response.body)
	 			@resultTemp = result["templates"]
			end

			it "gets all templates" do
				expect(@resultTemp.length).to eq(@t.length)
			end

			it "gets template data" do
				for i in 0..1
					expect(@resultTemp[i]["name"]).to eq(@t[i].name)
					expect(@resultTemp[i]["description"]).to eq(@t[i].description)
				end
			end
		end

		context "unsuccessful" do
			it "cannot get templates due to 'not trainer' error" do
				user = FactoryGirl.create(:student, id: 665)
	 			request.headers['Authorization'] =  user.auth_token
	 			get :index
	 			result = JSON.parse(response.body)
	 			expect(result["status"]).to eq(401)
	 			expect(result["errors"][0]).to eq('access denied to students')
			end
		end
	end

	#View Specific Game Template
	describe "GET #show" do
		context "successful" do
			it "gets specific template" do
				user = FactoryGirl.create(:trainer, id: 1234)
	 			request.headers['Authorization'] =  user.auth_token
	 			a = FactoryGirl.create(:game_template_a)
	 			FactoryGirl.create(:game_template_b)

	 			get :show, id: a.id
	 			result = JSON.parse(response.body)
	 			resultTemp = result["template"]
	 			expect(resultTemp).to be_instance_of(Hash)
 				expect(resultTemp).not_to be_instance_of(Array)
 				expect(resultTemp["name"]).to eq(a.name)
 				expect(resultTemp["description"]).to eq(a.description)
			end
		end
		context "unsuccessful" do
			it "cannot get template due to 'not trainer' error" do
				user = FactoryGirl.create(:student, id: 333)
	 			request.headers['Authorization'] =  user.auth_token

	 			get :show, id: 5
	 			result = JSON.parse(response.body)
	 			expect(result["status"]).to eq(401)
	 			expect(result["errors"][0]).to eq('access denied to students')
			end

			it "cannot get template due to 'not exist' error" do
				user = FactoryGirl.create(:trainer, id: 0020)
	 			request.headers['Authorization'] =  user.auth_token

	 			get :show, id: 5
	 			result = JSON.parse(response.body)
	 			expect(result["status"]).to eq(400)
	 			expect(result["errors"][0]).to eq('game template does not exist')
			end
		end
	end
end
