FactoryGirl.define do
  factory :question_set do 
  	id 5
    setname "simpleset"
    trainer_id 1234
	after(:create) do |set|
	    set.questions << create(:question, question_set: set)
	    set.questions << create(:question_color, question_set: set)
	end
  end
end
