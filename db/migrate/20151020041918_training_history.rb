class TrainingHistory < ActiveRecord::Migration
  def change
      create_table :traininghistory do |t|
          t.integer :gamehash, null: false
          t.integer :studenthash, null: false
          t.integer :score, null: false
          t.integer :lastq, null: false
          t.timestamps null: false
      end
    end
end
