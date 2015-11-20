FactoryGirl.define do
  factory :game do 
  	trainer_id 1111
  	game_template_id 1
    question_set_id 1

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


    #Find an existing associated object (also created by Factory)
    #but if none are found, build one on the spot

    before(:create) do |game|
      game.trainer = Trainer.find_by_id(game.trainer_id)
      if game.trainer.nil?
        game.trainer = create(:trainer, id: game.trainer_id)
      end

      game.question_set = QuestionSet.find_by_id(game.question_set_id)
      if game.question_set.nil?
        game.question_set = create(:question_set_repeat, id: game.question_set_id)
      end
      game.game_template = GameTemplate.find_by_id(game.game_template_id)
      if game.game_template.nil?
        game.game_template = create(:game_template_a, id: game.game_template_id)
      end
    end
  end
end