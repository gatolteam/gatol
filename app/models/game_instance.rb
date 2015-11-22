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

    def checkGameOngoing
		if self.active && self.lastQuestion == @qcount
			self.active = false
		end
	end

	##############################
	### QUERY METHODS ############
	##############################

    def self.getActiveGames(sid)
    	GameInstance.where(student_id: sid, active: true)
    end


	#Gets (score, date) tuples for a certain game and orders by student_id
	#If a student is specified, only scores for that student are returned
	def self.getAllScoresForGame(gid, sid=nil)
		if sid.nil?
			GameInstance.where(game_id: gid, active: false).order(student_id: :asc, score: :desc)
		else
			GameInstance.where(student_id: sid, game_id: gid, active: false).order(score: :desc)
		end
	end

	def self.getAllScoresForStudent(sid)
		GameInstance.where(student_id: sid, active: false).order(score: :desc)
	end

	def self.getTop(gid, x)
		GameInstance.where(game_id: gid, active: false).pluck(:score, :student_id, :updated_at).order(score: :desc).limit(x)
	end

	def self.getTop10(gid)
		self.getTop(gid, 10)
	end

	def self.getAllGameSummaries(tid)
		GameInstance.joins(:trainers).where(trainer_id: tid, active: false).group(:game_id, :student_id).limit(5).order(:student_id, :score)
		#games = GameInstance.select(:game_id).where(trainer_id: tid).group()
	end

	def self.getPlayerSummaries(gid)
		#GameInstance.where(game_id: gid, active: false).group(:student_id).maximum(:score)
		GameInstance.select("max(score) as highest_score", "avg(score) as avg_score").where(game_id: gid, active: false).group(:student_id)
	end

	def self.getRates(tid)
		#GameInstance.select("completion_rate","win_rate").where(trainer_id: tid).group(:game_id)
	end



end
