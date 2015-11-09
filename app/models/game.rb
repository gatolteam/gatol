#this describes a Game (based off GameTemplate) created by Trainer
class Game < ActiveRecord::Base
	belongs_to :trainer
	
end
