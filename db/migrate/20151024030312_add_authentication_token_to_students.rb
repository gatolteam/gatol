class AddAuthenticationTokenToStudents < ActiveRecord::Migration
  def change
    add_column :students, :auth_token, :string, default: ""
    add_column :students, :confirmed, :boolean, default: false
    add_index :students, :auth_token, unique: true
  end
end
