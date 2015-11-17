class CreateGameEnrollments < ActiveRecord::Migration
  def change
    create_table :game_enrollments do |t|
      t.integer :trainer_id
      t.integer :game_id
      t.string :student_email
      t.boolean :registered

      t.timestamps null: false
    end
  end
end
