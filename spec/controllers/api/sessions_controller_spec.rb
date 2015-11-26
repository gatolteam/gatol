require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do

	describe "POST#create" do
		before(:each) do
			@user = FactoryGirl.create :student
		end

		context "correct email and password" do
			before(:each) do
				credentials = { email: @user.email, password: "password1" }
				post :create, { session: credentials }
			end

			it "returns auth_token" do
				@user.reload
				user_response = JSON.parse(response.body, symbolize_names: true)
				expect(response.status).to eq(200)
			end


			it "status = 200" do
				expect(response.status).to eql 200
			end 

		end

		context "incorrect password" do
			before(:each) do
				credentials = { email: @user.email, password: "wrongpass" }
				post :create, { session: credentials }
			end

			it "returns error" do
				user_response = JSON.parse(response.body, symbolize_names: true)
				expect(user_response[:errors]).to eql ["Invalid password"]
			end

			it "status = 422" do
				expect(response.status).to eql 422
			end  
		end

	end



	describe "DELETE#destroy" do
		before(:each) do
			@user = FactoryGirl.create :student
			sign_in @user
			delete :destroy, id: @user.auth_token
		end

		it "status = 204" do
				expect(response.status).to eql 204
		end
	end  


end
