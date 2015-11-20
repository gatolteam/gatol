FactoryGirl.define do
  factory :game_instance do 
  	game_id 1
  	student_id 1234

    before(:create) do |inst|
      inst.student = Student.find_by_id(inst.student_id)
      if inst.student.nil?
        inst.student = create(:student, id: inst.student_id)
      end

      inst.game = Game.find_by_id(inst.game_id)
      if inst.game.nil?
        inst.game = create(:game, id: inst.game_id)
      end

    end

  		factory :game_instance_nonzero do
  			score 16
  			lastQuestion 1
  		end

      factory :game_instance_inactive do
        score 16
        lastQuestion 2
        active false
      end
  end
end