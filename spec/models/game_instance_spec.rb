require 'rails_helper'

RSpec.describe GameInstance, type: :model do
  describe "instance: updateScore" do
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

describe "getActive, getAllScoresFor*" do
	before(:each) do
		s = FactoryGirl.create(:student, id: 3)
		g = FactoryGirl.create(:game, id: 1)
		@a = FactoryGirl.create(:game_instance_inactive, score: 10, student_id: s.id, game_id: 1)
		@b = FactoryGirl.create(:game_instance_inactive, score: 20, student_id: s.id, game_id: 1)
		@c = FactoryGirl.create(:game_instance, score:5, student_id: s.id, game_id: 1)
		@d = FactoryGirl.create(:game_instance_inactive, score: 10, student_id: 2, game_id: 1)

		@sid = s.id
		@gid = g.id
	end

	it "only gets active" do
		inst = GameInstance.getActiveGames(@sid)
		expect(inst.length).to eq(1)
		expect(inst[0].id).to eq(@c.id)
	end

	it "gets all scores for one game (any student)" do
		FactoryGirl.create(:game_instance_inactive, game_id: 55)
		inst = GameInstance.getAllScoresForGame(@gid)
		expect(inst.length).to eq(3)
		expect(inst[2].id).to eq(@d.id)
		expect(inst[1].id).to eq(@a.id)
		expect(inst[0].id).to eq(@b.id)
	end

	it "gets all scores for one game, one student" do
		inst = GameInstance.getAllScoresForGame(@gid, @sid)
		expect(inst.length).to eq(2)
		expect(inst[1].id).to eq(@a.id)
		expect(inst[0].id).to eq(@b.id)
	end

	it "gets all scores for student (any game)" do
		e = FactoryGirl.create(:game_instance_inactive, game_id: 56, score: 30, student_id: @sid)
		inst = GameInstance.getAllScoresForStudent(@sid)
		expect(inst.length).to eq(3)
		expect(inst[1].id).to eq(@b.id)
		expect(inst[2].id).to eq(@a.id)
		expect(inst[0].id).to eq(e.id)

	end
end

  describe "getTop" do
	before(:each) do
		@sids = []
		@sids << FactoryGirl.create(:student)
		@sids << FactoryGirl.create(:student)
		@sids << FactoryGirl.create(:student)
		@g = FactoryGirl.create(:game, id: 5)
		#throw in an instance for some other game
		FactoryGirl.create(:game_instance_inactive, score: 23, student_id: @sids.sample.id)
	end

	it "gets the top 10 scores out of 15" do
		expected = createInstances(5, 15, @sids, @g.id)

		actual = GameInstance.getTop10(@g.id)
		expect(actual.length).to eq(10)
		checkTopInstances(actual, expected, 10)
	end

	it "gets all scores ordered out of 5 for top 10" do
		expected = createInstances(0, 5, @sids, @g.id)

		actual = GameInstance.getTop10(@g.id)
		expect(actual.length).to eq(5)
		checkTopInstances(actual, expected, 5)
	end
  end

  describe "getPlayerSummaries" do
  	before(:each) do
  		@t = FactoryGirl.create(:trainer, id: 5)
  		@g = []
		@g << FactoryGirl.create(:game, trainer_id: @t.id)
		@g << FactoryGirl.create(:game, trainer_id: @t.id)

		@sids = []
		@sids << FactoryGirl.create(:student)
		@sids << FactoryGirl.create(:student)
		createInstancesNonrandom(2, 4, @sids, @g[0].id)
		createInstancesNonrandom(2, 4, @sids, @g[1].id)
  	end

	it "gets all summaries for player" do
		result = GameInstance.getPlayerSummaries(@g[0].id)
		expect(result.length).to eq(2)
		expect(result[0][:avg_score]).to eq(3)
		expect(result[0][:highest_score]).to eq(4)
		expect(result[0][:student_id]).to eq(@sids[0].id)

		expect(result[1][:avg_score]).to eq(2)
		expect(result[1][:highest_score]).to eq(3)
		expect(result[1][:student_id]).to eq(@sids[1].id)

	end
  end

  describe "getAllGameSummaries" do
  	before(:each) do
  		@t = FactoryGirl.create(:trainer)
  		@g = []
		@g << FactoryGirl.create(:game, trainer_id: @t.id)
		@g << FactoryGirl.create(:game, trainer_id: @t.id)

		@sids = []
		@sids << FactoryGirl.create(:student)
		@sids << FactoryGirl.create(:student)
		@inst = []
		@inst << createInstancesNonrandom(2, 4, @sids, @g[0].id)
		@inst << createInstancesNonrandom(2, 5, @sids, @g[1].id)
  	end

	it "gets all summaries for trainer's games" do
		result = GameInstance.getAllGameSummaries(@t.id)

		expect(result.length).to eq(2)
		checkGameSummaries(result)

	end
  end


########## HELPER METHODS ###########

def failUpdate(newScore, newQuestion)
	old_score = @i.score
	old_q = @i.lastQuestion
	@i.update(newScore, newQuestion)
	expect(@i.score).to eq(old_score)
	expect(@i.lastQuestion).to eq(old_q)
end


def createInstances(bad, total, sids, gid)
	a = []
	for i in 1..bad
		x = FactoryGirl.create(:game_instance_inactive, score: i, student_id: sids.sample.id, game_id: gid)
		a << x
	end

	# the latter part of the array
	for i in bad+1..total
		x =  FactoryGirl.create(:game_instance_inactive, score: i, student_id: sids.sample.id, game_id: gid)
		a << x
	end
	return a
end

def createInstancesNonrandom(bad, total, sids, gid)
	a = []
	for i in 1..bad
		sidx = i % sids.length
		x = FactoryGirl.create(:game_instance_inactive, score: i, student_id: sids[sidx].id, game_id: gid)
		a << x
	end

	# the latter part of the array
	for i in bad+1..total
		sidx = i % sids.length
		x =  FactoryGirl.create(:game_instance_inactive, score: i, student_id: sids[sidx].id, game_id: gid)
		a << x
	end
	return a
end

def checkTopInstances(actual, expected, num)
	total = expected.length-1
	for i in 0..num-1
		expect(actual[i].id).to eq(expected[total-i].id)
		expect(actual[i].score).to eq(expected[total-i].score)
		expect(actual[i].game_id).to eq(expected[total-i].game_id)
	end

end


def checkGameSummaries(result)
	k = @g.length - 1
	for i in 0..k
		game = @g[i]
		top = result[game.id]
		actual = @inst[i].length
		expect(top.length).to eq(actual)
		for j in 0..top.length-1
			expect(top[j].id).to eq(@inst[i][actual-1-j].id)
			expect(top[j].score).to eq(@inst[i][actual-1-j].score)
		end
	end
end

end