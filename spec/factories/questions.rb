FactoryGirl.define do
  factory :question do
  	questionIdx 0
  	question "1+1 = ?"
  	answerCorrect "2"
  	answerWrong1 "3"
  	answerWrong2 "4"
  	answerWrong3 "5"
  	answerWrong4 "6"
  	answerWrong5 "7"
  	answerWrong6 "8"
  	answerWrong7 "9"

  	factory :question_color do
	  	questionIdx 1
	  	question "Which is not a color?"
	  	answerCorrect "potato"
	  	answerWrong1 "blue"
	  	answerWrong2 "black"
	  	answerWrong3 "red"
	  	answerWrong4 "fuschia"
	  	answerWrong5 "aqua"
	  	answerWrong6 nil
	  	answerWrong7 nil
	  end
  end

end
