FactoryGirl.define do
  factory :game_enrollment do
    trainer_id 1
	game_id 1
	student_email { FFaker::Internet.email }
	registered false
  end
end
