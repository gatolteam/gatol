require 'rails_helper'

RSpec.describe QuestionSet do

  context "create trivial QuestionSet" do
  	before(:context) do
  		@qs = QuestionSet.new(setname: 'simpleset')
  	end

	  it "initializes setname" do
	  	expect(@qs.setname).to eq('simpleset')
	  end

	  it "initializes question array" do
	  	expect(@qs.qs).to eq([])
	  end
	end

  context "parse CSV using fixture_file_upload" do
  	before(:context) do
  		@qsa = QuestionSet.parseCSV("#{Rails.root}/spec/fixtures/files/demo1.csv")
  	end
	  it "parses all rows of CSV file " do
	  	expect(@qsa.length).to eq(3)
	  end

	  it "parses all columns of CSV file " do
	  	expect(@qsa[0].length).to eq(9)
	  	expect(@qsa[1].length).to eq(9)
	  	expect(@qsa[2].length).to eq(9)
	  end

	  it "parses data of CSV file correctly" do
	  	arr = [ [ 'Question','Correct Answer','Wrong Answer 1','Wrong Answer 2','Wrong Answer 3','Wrong Answer 4','Wrong Answer 5','Wrong Answer 6','Wrong Answer 7'], 
	  			['T/F: Apples are always red','F','T',nil,nil,nil,nil,nil,nil], 
	  			['1+1?','2','1','3','4','5','6','7','8'],
				['Can sheep fly?','No','Of course!','Meep',nil,nil,nil,nil,nil]  ]
		expect(@qsa.to_a).to eq(arr)
	  end
	end

  context "parse CSV using ActionDispatch::Http::UploadedFile" do
  	before(:context) do

  		f = ActionDispatch::Http::UploadedFile.new({
  				:filename => 'demo1.csv',
    			:type => 'text/csv',
    			:tempfile => File.new("#{Rails.root}/spec/fixtures/files/demo1.csv")
  			})

  		@qsa = QuestionSet.parseCSV(f)
  	end
	  it "parses all rows of CSV file " do
	  	expect(@qsa.length).to eq(3)
	  end

	  it "parses all columns of CSV file " do
	  	expect(@qsa[0].length).to eq(9)
	  	expect(@qsa[1].length).to eq(9)
	  	expect(@qsa[2].length).to eq(9)
	  end

	  it "parses data of CSV file correctly" do
	  	arr = [ [ 'Question','Correct Answer','Wrong Answer 1','Wrong Answer 2','Wrong Answer 3','Wrong Answer 4','Wrong Answer 5','Wrong Answer 6','Wrong Answer 7'], 
	  			['T/F: Apples are always red','F','T',nil,nil,nil,nil,nil,nil], 
	  			['1+1?','2','1','3','4','5','6','7','8'],
				['Can sheep fly?','No','Of course!','Meep',nil,nil,nil,nil,nil]  ]
		expect(@qsa.to_a).to eq(arr)
	  end
	end




  context "create QuestionSet from array" do
  	before(:context) do
  		@arr = [ ['1+1?','2','1','3','4','5','6','7','8'],
				['Can pigs fly?','No','Of course!','Meep','','','','',''],
				['T/F: Banana is a fruit','T','F','','','','','','']  ]

		@set = QuestionSet.new(setname: '3set')
		@set.createQuestions(@arr)
		@sarr = @set.qs


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
			expect(@qarr[i].answerCorrect).to eq(@sarr[i].answerCorrect)
			for j in 0..6
				expect(@qarr[i].answerWrong[j]).to eq(@sarr[i].answerWrong[j])
			end
		end
    end

    it "saves all Questions in QuestionSet" do
    	expect { @set.saveSet }.not_to raise_error
  	end
  end

end
