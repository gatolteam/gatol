require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
	def setup
		#question = 'Which is not a color?'
		#answerCorrect = 'potato'
		#answerWrong  = []
		#@input = {:question => }
	end

	def teardown
	end

	#test "intialize_test" do 
	#end

	test "fromStringArray" do
		arr = ['1+1?','2','1','3','4','5','6','7','8']
		q = Question.new(arr)
		assert_equal(arr[0], q.question, "Parsed question statement incorrectly")
		assert_equal(arr[1], q.answerCorrect, "Parsed correct answer incorrectly")
		for i in 0..6
           assert_equal(arr[i+2], q.answerWrong[i], "Parsed wrong answer #{i+1} incorrectly")
        end
        assert_equal(7, q.answerWrong.length, "Wrong answer array not of length 7")
	end
end
