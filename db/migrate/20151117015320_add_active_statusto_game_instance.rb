class AddActiveStatustoGameInstance < ActiveRecord::Migration
  def change
  	add_column :training_history, :active, :boolean, :default => true
  end
end
