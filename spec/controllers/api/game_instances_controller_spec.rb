require 'rails_helper'

RSpec.describe Api::GameInstancesController, type: :controller do

	#View Game Summary
	describe "GET #index" do
		context "successful by trainer" do
			pending
		end
		context "successful by student" do
			pending
		end
		context "unsuccessful by trainer" do
			pending
		end
		context "unsuccessful by student" do
			pending
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
			pending
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

end
