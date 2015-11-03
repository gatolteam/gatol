require 'rails_helper'

RSpec.describe Question, type: :model do

  it "cannot save an empty question" do
  	@q = Question.new
  	expect { @q.save }.to raise_error
  end

  context "Question is not empty"
  	before (:context) do
  		@sid = 5
  		@sname = 'simple'
  		@qid = 0
  		@arr = ['1+1?','2','1','3','4','5','6','7','8']
  		@q = Question.new(setid: @sid, 
  						  setname: @sname, 
  						  questionIdx: @qid)
  		@q.buildQuestion(@arr)
  	end

  	it "sets the setid" do
  		expect(@q.setid).to eq(@sid)
  	end

  	it "sets the setname" do
  		expect(@q.setname).to eq(@sname)
  	end

  	it "sets the questionIdx" do
  		expect(@q.questionIdx).to eq(@qid)
  	end

  	it "sets the question" do
  		expect(@q.question).to eq(@arr[0])
  	end

  	it "sets the correct answer" do
  		expect(@q.answerCorrect).to eq(@arr[1])
  	end

  	it "sets the right number of wrong answers" do
  		expect(@q.answerWrong.length).to eq(7)
  	end

  	it "sets the wrong answers in answerWrong array" do
  		for i in 0..6
           expect(@q.answerWrong[i]).to eq(@arr[i+2])
        end
    end

  	it "sets all the wrong answers fields" do
  		expect(@q.answerWrong1).to eq(@arr[2])
  		expect(@q.answerWrong2).to eq(@arr[3])
  		expect(@q.answerWrong3).to eq(@arr[4])
  		expect(@q.answerWrong4).to eq(@arr[5])
  		expect(@q.answerWrong5).to eq(@arr[6])
  		expect(@q.answerWrong6).to eq(@arr[7])
  		expect(@q.answerWrong7).to eq(@arr[8])
  	end

  	it "saves sucessfully" do
  		expect(@q.save).to be_truthy
  	end
end
