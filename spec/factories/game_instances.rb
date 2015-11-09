FactoryGirl.define do
  factory :game_instance do 
  	game_id
  	student_id
  	score 0
  	lastQuestion 0
  		factory :game_instance_nonzero do
  			score 16
  			lastQuestion 5
  		end
  end
end