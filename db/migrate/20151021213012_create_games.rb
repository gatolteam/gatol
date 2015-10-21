class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :gamehash, null: false
      t.integer :trainerhash, null: false
      t.integer :sethash, null: false
      t.integer :gametempid, null: false
      t.string :description, limit: 256, null: false

      t.timestamps
    end
  end
end
