class RemoveHashFields < ActiveRecord::Migration
  def change
	#Game Templates
  	remove_column :game_templates, :hash

  	remove_column :games, :gamehash

  	remove_column :question_sets, :qhash
  	remove_column :question_sets, :sethash	

  end
end
