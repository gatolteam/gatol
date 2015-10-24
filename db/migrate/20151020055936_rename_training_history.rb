class RenameTrainingHistory < ActiveRecord::Migration
  def change
      rename_table :trainhistory, :training_history
      rename_table :questionsets, :question_sets
      rename_table :gametemplates, :game_templates
  end
end
