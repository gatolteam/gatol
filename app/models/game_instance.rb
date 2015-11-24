class GameInstance < ActiveRecord::Base
	self.table_name = "training_history"
	belongs_to :student
	belongs_to :game

	validates_presence_of :student
	validates_presence_of :game

	after_initialize do |g|
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
		GameInstance.joins(:student).select(:id, :game_id, 'students.email as email', :score).where(game_id: gid, active: false).order(score: :desc).limit(x)
	end

	def self.getTop10(gid)
		self.getTop(gid, 10)
	end

	def self.getAllGameSummaries(tid)
		GameInstance.joins(:game).select(:id, :score, :student_id, 'games.id as game_id').where(active: false, games: { trainer_id: tid }).group('games.id', :student_id).order(:student_id, :score).limit(5)
		#games = GameInstance.select(:game_id).where(trainer_id: tid).group()
	end

	def self.getPlayerSummaries(gid)
		#GameInstance.where(game_id: gid, active: false).group(:student_id).maximum(:score)
		GameInstance.select("max(score) as highest_score", "avg(score) as avg_score", :student_id).where(game_id: gid, active: false).group(:student_id).order(student_id: :asc)
	end

	def self.getRates(tid)
		#GameInstance.select("completion_rate","win_rate").where(trainer_id: tid).group(:game_id)
	end



end
