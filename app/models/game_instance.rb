class GameInstance < ActiveRecord::Base
	self.table_name = "training_history"
	belongs_to :student
	belongs_to :game
	#attr_accessor :

	validates_presence_of :student
	validates_presence_of :game

	after_initialize do |g|
        self.score = 0
		self.lastQuestion = 0
		@qcount = nil
    end


    #Returns true if update succeeds and false if not
    #Will raise ArgumentError if lastQuestion is invalid
    def update(score, lastQuestion)
    	if self.active
    		if @qcount.nil?
				@qcount = self.game.question_set.getNumberQuestions
			end
    		if lastQuestion > @qcount
    			raise ArgumentError, 'invalid lastQuestion: exceeds number of questions'
    		elsif lastQuestion < self.lastQuestion
    			raise ArgumentError, 'invalid lastQuestion: smaller than last stored question number'
    		else
    			self.score = score
    			self.lastQuestion = lastQuestion
    			checkGameOngoing
    			self.save!
    		end
    	end
    	self.active
    end

	#Gets (score, date) tuples for a classertain game and orders by student_id
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

	def checkGameOngoing
		if self.active && self.lastQuestion == @qcount
			self.active = false
		end
	end

end
