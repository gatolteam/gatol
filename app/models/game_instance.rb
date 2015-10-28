class GameInstance < ActiveRecord::Base
	self.table_name = "training_history"
	def initialize
		self.score = 0
		self.lastq = 0
	end
end
