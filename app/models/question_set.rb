class QuestionSet < ActiveRecord::Base 
    require 'csv'


    #initializes 
    def initialize(params)
        #@setid = self.setid
        #@setname = self.setname
        @questions = []
        
    end
    
    #creates a new QuestionSet
    def createSet
    end
    
    # turns the array d of array of strings into a Question object
    def createQuestions(q)
    end

    # parses CSV
    # Using the rails' csv library, a line of csv such as 
    #                  1+1?,2,1,3,4,5,6,7,8
    # will be parsed into
    #                  ['1+1?','2','1','3','4','5','6','7','8']
    # and encapsualted in another array containing all the lines of CSV
    def parseCSV
    end
    
    
    
    
    
end
