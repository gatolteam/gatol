class Question < ActiveRecord::Base 
    belongs_to :question_set
	attr_accessor :answerWrong

    def buildQuestion(params)
    	@answerWrong = Array.new(7)
    	if !params.nil?
        	extractFields(params)
        	setWrongAnswers
        end
    end

    def extractFields(s)
    	self.question = s[0]
    	self.answerCorrect = s[1]
    	for i in 0..6
    		if s[i+2].empty?
    			@answerWrong[i] = nil
    		else
            	@answerWrong[i] = s[i+2]
            end
        end
    end

   	def getWrongAnswerByIndex(i)
    	return @answerWrong[i]
	end
    
	def setWrongAnswers
		self.answerWrong1 = @answerWrong[0]
		self.answerWrong2 = @answerWrong[1]
		self.answerWrong3 = @answerWrong[2]
		self.answerWrong4 = @answerWrong[3]
		self.answerWrong5 = @answerWrong[4]
		self.answerWrong6 = @answerWrong[5]
		self.answerWrong7 = @answerWrong[6]
	end

end
