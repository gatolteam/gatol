require 'rails_helper'

RSpec.describe Api::QuestionSetsController, type: :controller do

	describe "GET #index" do
		before(:each) do
			@user = FactoryGirl.create(:trainer, id: 1234)
			request.headers['Authorization'] =  @user.auth_token
			FactoryGirl.create(:question_set)
		end
		it "gets all the QuestionSets belonging to a User" do
			get :index
			puts response.body

		end
	end
end
