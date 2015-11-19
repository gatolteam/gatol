require 'rails_helper'

RSpec.describe GameInstance, type: :model do
  describe "updateScore" do
  	before(:each) do
  		@i = FactoryGirl.create(:game_instance)
  	end

  	it "updates score correctly (from 0)" do
  		pending


  	end

  	it "updates score correctly (from nonzero)" do
  		pending
  	end

  	it "detects last question" do
  		pending
  	end

  	it "only updates score for active game" do
  		pending
  	end
  end
end
