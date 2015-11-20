class GameInstance < ActiveRecord::Base
	self.table_name = "training_history"
	belongs_to :student
	belongs_to :game

	validates_presence_of :student
	validates_presence_of :game

	after_initialize do |g|
        self.score = 0
		self.lastQuestion = 0
    end

    def update(score, lastQuestion)
    	self.score = x
    	self.lastQuestion = lastQuestion
    	self.save
    end

	def updateScore(x)
		self.score = x
		self.save
	end

	def updateScoreByVal(x)
		self.score = self.score + x
		self.save
	end

	def updateLastQuestion(i)
		self.lastQuestion = i
		self.save
	end

	#Gets (score, date) tuples for a certain game and orders by student_id
	#If a student is specified, only scores for that studeny are returned
	def self.getAllScoresForGame(gid, tid, sid=nil)
		if sid.nil?
			GameInstance.where(trainer_id: tid, game_id: gid, active: false).pluck(:score, :updated_at).order(:student_id, :score)
		else
			GameInstance.where(student_id: sid, trainer_id: tid, game_id: gid, active: false).pluck(:score, :updated_at).order(:score)
		end
	end

	def self.getHighScoresForGame(tid, gid)
		#GameInstance.where(trainer_id: tid, game_id: gid)
	end

	def self.getGameRanking(gid)
	end

end
