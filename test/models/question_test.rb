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

	test "noSimpleSave" do
		q = Question.new
		assert_raises do
			q.save
		end
	end

	test "buildQuestion" do
		arr = ['1+1?','2','1','3','4','5','6','7','8']
		q = Question.new(setid: 5, setname: 'simple', questionIdx: 0)
		q.buildQuestion(arr)
		assert_equal(arr[0], q.question, "Parsed question statement incorrectly")
		assert_equal(arr[1], q.answerCorrect, "Parsed correct answer incorrectly")
		for i in 0..6
           assert_equal(arr[i+2], q.answerWrong[i], "Parsed wrong answer #{i+1} incorrectly")
        end
        assert_equal(7, q.answerWrong.length, "Wrong answer array not of length 7")

        assert_equal(arr[2], q.answerWrong1, "Wrong answer 1 set incorrectly")
        assert_equal(arr[3], q.answerWrong2, "Wrong answer 2 set incorrectly")
        assert_equal(arr[4], q.answerWrong3, "Wrong answer 3 set incorrectly")
        assert_equal(arr[5], q.answerWrong4, "Wrong answer 4 set incorrectly")
        assert_equal(arr[6], q.answerWrong5, "Wrong answer 5 set incorrectly")
        assert_equal(arr[7], q.answerWrong6, "Wrong answer 6 set incorrectly")
        assert_equal(arr[8], q.answerWrong7, "Wrong answer 7 set incorrectly")
        assert(q.save, "Did not save successfully")
	end
end
