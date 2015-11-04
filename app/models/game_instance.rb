class GameInstance < ActiveRecord::Base
	self.table_name = "training_history"
	def initialize
		self.score = 0
		self.lastQuestion = 0
	end
end
