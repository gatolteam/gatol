class AddDefaultValues < ActiveRecord::Migration
  def change
  	change_column :training_history, :score, :integer, :default => 0
  	change_column :training_history, :lastQuestion, :integer, :default => 0
  end
end
