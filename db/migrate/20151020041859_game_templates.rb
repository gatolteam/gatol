class GameTemplates < ActiveRecord::Migration
  def change
      create_table :gametemplates do |t|
          t.integer :hash, null: false
          t.string :name, null: false
          t.string :description, limit: 256, null: false
          
          t.timestamps null: false
      end
    end
end
