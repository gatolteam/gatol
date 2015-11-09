FactoryGirl.define do
  factory :game_template do 
  	factory :game_template_a do
	  	name "Blobbers"
	  	description "A bubbly game"
	end
	factory :game_template_b do
	  	name "Pitfall"
	  	description "fallure is imminent"
	end
  end
end