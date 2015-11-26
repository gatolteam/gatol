class QuestionSet < ActiveRecord::Base 
    require 'csv'
    belongs_to :trainer
    has_many :questions
    attr_accessor :qs, :qcount
    validates_presence_of :trainer


    after_initialize do |set|
        @qs = []
        @qcount = 0
    end

    @headers = [ 'Question','Correct Answer','Wrong Answer 1','Wrong Answer 2','Wrong Answer 3','Wrong Answer 4','Wrong Answer 5','Wrong Answer 6','Wrong Answer 7']
    
    #sets up new QuestionSet
    def createSet(file, params={})
        if !params.empty?
            if params.key?(:trainer_id)
                self.trainer_id = params[:trainer_id]
            end
            if params.key?(:setname)
                self.setname = params[:setname]
            end
        end
        if self.setname.nil?
            t = Time.now.strftime("%Y%m%d_%H%M%S")
            self.setname = "QSET_#{self.id}_#{t}"
        end

        arr = QuestionSet.parseCSV(file)
        createQuestions(arr)
    end
    
    # turns the array d of array of strings into an array of Question objects
    def createQuestions(arr)
        @qcount = arr.length
        for i in 0..@qcount-1
            q = Question.new
            q.buildQuestion(arr[i])
            q.question_set = self
            q.questionIdx = i
            @qs.push(q)
        end
    end

    def saveSet
        all = true
        @qs.each do |q|
            all = all && q.save!
        end
        all && self.save!
    end

    # parses CSV
    # Using the rails' csv library, a line of csv such as 
    #                  1+1?,2,1,3,4,5,6,7,8
    # will be parsed into
    #                  ['1+1?','2','1','3','4','5','6','7','8']
    # and encapsualted in another array containing all the lines of CSV
    def self.parseCSV(file)
        csvFile = file
        if file.is_a?(ActionDispatch::Http::UploadedFile)
            csvFile = file.tempfile
        end

        arr = self.checkCSV(csvFile)
    end
    
    def getQuestionByIndex(i)
        if (i > 0 && i < @qs.length)
            return @qs[i]
        else
        #Raise Exception here?
        end
    end

    def getQuestions
        @qs = self.qs
    end

    def getNumberQuestions
        if @qcount == 0 && @qs.empty?
            @qcount = self.questions.count
            return @qcount
        else
            return @qcount
        end
    end

    def self.checkCSV(file)
        arr = CSV.read(file, headers: true)
        headers = arr.headers()
        if (headers.length != @headers.length)
            raise "Invalid CSV: bad header length #{headers.length}, CSV must have exactly 9 columns"
        end
        (0..8).each do |i|
            if headers[i].nil?
                raise "Invalid CSV: missing header column '#{@headers[i]}'"
            elsif (headers[i].strip() != @headers[i])
                raise "Invalid CSV: bad CSV column '#{headers[i]}' should be '#{@headers[i]}'"
            end
        end
        return arr
    end
end
