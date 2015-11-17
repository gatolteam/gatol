class GameInstance < ActiveRecord::Base
	belongs_to :student
	belongs_to :game
	
	self.table_name = "training_history"
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
end
