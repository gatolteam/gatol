class QuestionSets < ActiveRecord::Migration
  def change
      create_table :question_sets do |t|
          t.integer :qid, null: false
          t.integer :qhash, null: false
          t.integer :setid, null: false
          t.integer :sethash, null: false
          t.string :setname, limit: 128, null: false
          t.integer :questionindex, null: false
          t.string :question, limit: 256, null: false
          t.string :answerCorrect, limit: 256, null: false
          t.string :answerWrong1, limit: 256
          t.string :answerWrong2, limit: 256
          t.string :answerWrong3, limit: 256
          t.string :answerWrong4, limit: 256
          t.string :answerWrong5, limit: 256
          t.string :answerWrong6, limit: 256
          t.string :answerWrong7, limit: 256
          
          t.timestamps null: false
      end
  end
end
