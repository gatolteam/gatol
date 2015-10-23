require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
	def setup
		question = 'Which is not a color?'
		answerCorrect = 'potato'
		answerWrong  = []
		#@input = {:question => }
	end

	test "intialize_test" do 
	end

	test "fromStringArray_test" do
		arr = ['1+1?','2','1','3','4','5','6','7','8']
		q = Question.new(arr)
		assert_equal(arr[0], q.question)
		assert_equal(arr[1], q.answerCorrect)
		for i in 0..6
           assert_equal(arr[i+2], q.answerWrong[i])
        end
        assert_equal(7, q.answerWrong.length)

	end
end
