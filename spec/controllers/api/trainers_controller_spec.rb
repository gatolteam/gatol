require 'rails_helper'

RSpec.describe Api::TrainersController, type: :controller do

	describe "GET #show" do
		before(:each) do
			@user = FactoryGirl.create :trainer
			get :show, id: @user.id, foramt: :json
		end


		it "returns email" do
			user_response = JSON.parse(response.body, symbolize_names: true)
			expect(user_response[:email]).to eql @user.email
		end


		it "status = 200" do
			expect(response.status).to eql 200
		end
	end
end
