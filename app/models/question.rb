class Question
	attr_accessor :question, :answerCorrect, :answerWrong
    def initialize(params=nil)
    	@question = nil
    	@answerCorrect = nil
    	@answerWrong = Array.new(7)
    	if !params.nil?
        	fromStringArray(params)
        end
    end

    def fromStringArray(s)
    	@question = s[0]
    	@answerCorrect = s[1]
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
    
end
