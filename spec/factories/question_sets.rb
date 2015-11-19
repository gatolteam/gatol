FactoryGirl.define do
  factory :question_set do 
    setname "simpleset"
    trainer_id 1234

    before(:create) do |set|
      set.trainer = Trainer.find_by_id(set.trainer_id)
      if set.trainer.nil?
        set.trainer = create(:trainer, id: set.trainer_id)
      end
    end


    # factory will generate a set with 2 of the same question by default
    # use `create(:question_set_repeat, question_count: 15)`,
    # 		replacing 15 with the desired question repeat count.
    factory :question_set_repeat do
    	transient do
    		question_count 2
    	end
      after(:create) do |set, evaluator|
        create_list(:question, evaluator.question_count, question_set: set)
      end
  	end

  	# factory will generate a set with 2 different questions
  	factory :question_set_varied do
      after(:create) do |set|
        set.questions << create(:question, question_set: set)
	    set.questions << create(:question_color, question_set: set)
      end
  	end


  end
end
