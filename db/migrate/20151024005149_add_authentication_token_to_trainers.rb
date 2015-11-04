class AddAuthenticationTokenToTrainers < ActiveRecord::Migration
  def change
    add_column	:trainers, :auth_token, :string, default: ""
    add_column 	:trainers, :confirmed,	default: false
    add_index	:trainers, :auth_token, unique: true

  end
end