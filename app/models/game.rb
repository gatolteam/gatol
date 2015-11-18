#this describes a Game (based off GameTemplate) created by Trainer
class Game < ActiveRecord::Base
	belongs_to :trainer
	has_many :game_instances
	validates :name, presence: true, length: { 
		minimum: 1,
		maximum: 128,
		too_short: "must have at least %{count} characters",
		too_long: "must have at most %{count} characters"
	}
	validates :description, presence: true, length: { 
		minimum: 1,
		maximum: 256,
		too_short: "must have at least %{count} characters",
		too_long: "must have at most %{count} characters"
	}
	#validates_presence_of :trainer
	#validates :question_set, presence: true
	#validates :game_template, presence: true
	
end
