require 'test_helper'

class QuestionSetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

	def setUp
		#@setOne = QuestionSet.new
	end

	def teardown
	end

	def setUp1
		@arr = [ ['1+1?','2','1','3','4','5','6','7','8'],
				['Can pigs fly?','No','Of course!','Meep','','','','',''],
				['T/F: Banana is a fruit','T','F','','','','','','']  ]

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

	test "createQuestions" do
		setUp1
		arr = @arr
		qarr = @qarr

		set = QuestionSet.new

		set.createQuestions(arr)
		sarr = set.questions
		assert_equal(3, sarr.length, "Generated question array of wrong size")
		for i in 0..2
			assert_equal(qarr[i].question, sarr[i].question, "Q#{i} question does not match")
			assert_equal(qarr[i].answerCorrect, sarr[i].answerCorrect, "Q#{i} correct ans does not match")
			for j in 0..6
				assert_equal(qarr[i].answerWrong[j], sarr[i].answerWrong[j], "Q#{i} wrong ans #{j} does not match")
			end
		end

	end

	test "saveRecord" do
		setUp1
		@set = QuestionSet.new
		@set.createQuestions(@arr)
		#now insert other required data
		@set.setname = 'testset'
		@set.setid = 1
		assert_equal(1, set.save, "save failed")

	end

	test "parseCSV" do
	end

end
