require 'rails_helper'

RSpec.describe GameInstance, type: :model do
  describe "updateScore" do
  	context "successful" do
	  	before(:each) do
	  		@i = FactoryGirl.create(:game_instance)
	  		@i.update(10, 1)
	  	end

	  	it "updates score correctly (from 0)" do
	  		expect(@i.score).to eq(10)
	  		expect(@i.lastQuestion).to eq(1)
	  	end

	  	it "updates score correctly (from nonzero)" do
	  		@i.update(20, 2)
	  		expect(@i.score).to eq(20)
	  		expect(@i.lastQuestion).to eq(2)
	  	end

	  	it "detects last question" do
	  		@i.update(20, 2)
	  		expect(@i.active).to be_falsey
	  	end
	end

	context "unsuccessful" do
		before(:each) do
	  		@i = FactoryGirl.create(:game_instance_nonzero)
	  	end

	  	it "only updates score for active game" do
	  		@i.update(20, 2)
	  		failUpdate(30, 3)
	  	end

	  	it "does not update lastQuestion greater than actual" do
	  		expect {failUpdate(30, 10)}.to raise_error(ArgumentError)
	  	end

	  	it "does not update lastQuestion less than previous" do
	  		expect {failUpdate(30, 0)}.to raise_error(ArgumentError)
	  	end
	  end
  end

def failUpdate(newScore, newQuestion)
	old_score = @i.score
	old_q = @i.lastQuestion
	@i.update(newScore, newQuestion)
	expect(@i.score).to eq(old_score)
	expect(@i.lastQuestion).to eq(old_q)
end
end