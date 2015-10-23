class Question
#class Question < ActiveRecord::Base
    def initialize(params)
        fromStringArray(params)
    end

    def fromStringArray(s)
    	@question = s[0]
    	@answerCorrect = s[1]
    	@answerWrong = Array.new(7)
    	for i in 0..6
            @answerWrong[i] = s[i+2]
        end
    end
    
end
