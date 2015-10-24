class AddAuthenticationTokenToStudents < ActiveRecord::Migration
  def change
    add_column :students, :auth_token, :string, default: ""
    add_index :students, :auth_token, unique: true
  end
end
