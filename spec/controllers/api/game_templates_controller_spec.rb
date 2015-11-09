require 'rails_helper'

RSpec.describe Api::GameTemplatesController, type: :controller do

	# View Game Templates
	describe "GET #index" do
		context "successful" do
			before(:each) do
				@user = FactoryGirl.create(:trainer, id: 1234)
	 			request.headers['Authorization'] =  @user.auth_token

	 			FactoryGirl.create(:game_template)

			end
			

		end
		context "unsuccessful: not trainer" do
			pending
		end
	end

	#View Specific Game Template
	describe "GET #show" do
		context "successful" do
			pending
		end
		context "unsuccessful: not trainer" do
			pending
		end
	end


end
