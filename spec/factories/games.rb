FactoryGirl.define do
  factory :game do 
  	trainer_id 1111
  	game_template_id 0
  	factory :game_a do
  		question_set_id 15
  		name "BlobberBuddy"
  		description "lazy bubbles"
  	end

  	factory :game_b do
  		question_set_id 13
  		name "TicTacToe"
  		description "an easy game"
  	end
  	
  end
end