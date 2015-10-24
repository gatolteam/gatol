class RenameHashToId < ActiveRecord::Migration
  def change
  	rename_column :games, :trainerhash, :trainerid
  	rename_column :games, :sethash, :setid

  	rename_column :training_history, :gamehash, :gameid
  	rename_column :training_history, :studenthash, :studentid
  end
end
