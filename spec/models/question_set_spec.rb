require 'rails_helper'

RSpec.describe QuestionSet do

  it "cannot save an empty question set" do
  end

  it "gets correct setid for new set" do

  end

  it "initializes new QuestionSet" do
  	qs = QuestionSet.new(setname: 'simpleset')

  end

  it "parses CSV file correctly" do
  end

  context "create QuestionSet from array"
  	before(:context) do
  		@arr = [ ['1+1?','2','1','3','4','5','6','7','8'],
				['Can pigs fly?','No','Of course!','Meep','','','','',''],
				['T/F: Banana is a fruit','T','F','','','','','','']  ]

		@set = QuestionSet.new('3set')
		@set.createQuestions(@arr)
		@sarr = @set.questions


		q0 = Question.new
		q0.question = '1+1?'
		q0.answerCorrect = '2'
		q0.answerWrong = ['1','3','4','5','6','7','8']

		q1 = Question.new
		q1.question = 'Can pigs fly?'
		q1.answerCorrect = 'No'
		q1.answerWrong = ['Of course!','Meep',nil,nil,nil,nil, nil]

		q2 = Question.new
		q2.question = 'T/F: Banana is a fruit'
		q2.answerCorrect = 'T'
		q2.answerWrong = ['F',nil,nil,nil,nil,nil, nil]

		@qarr = [q0, q1, q2]
  	end

  	it "creates correct numnber of Questions" do
  		expect(@sarr.length).to eq(@arr.length)
  	end

  	it "creates correct Question objects for each csv question" do
  		for i in 0..2
			expect(@qarr[i].question).to eq(@sarr[i].question)
			expect(qarr[i].answerCorrect).to eq(@sarr[i].answerCorrect)
			for j in 0..6
				expect(qarr[i].answerWrong[j]).to eq(sarr[i].answerWrong[j])
			end
		end
    end

    it "saves all Questions in QuestionSet" do
    	expect { out = @set.saveSet }.not_to raise_error
    	expect(out).to be_truthy
  	end

end
