require 'net/smtp'

class Api::TrainersController < ApplicationController
	before_action :authenticate_with_token!, only: [:update, :destroy]
	respond_to :json

	def show
    user = Trainer.find(params[:id])
		render json: { id: user[:id], email: user[:email], password: user[:password], auth_token: user[:auth_token], confirmed: user[:confirmed]}, status: 200
	end


  def create
    if Student.find_by(email: params[:email]).nil?
      user = Trainer.new(:email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation], :username => params[:username])
      if user.save
        if (params[:email].end_with? "gmail.com") || (params[:email].end_with? "berkeley.edu")
          WelcomeMailer.verification_email(user).deliver_now
        end
        render json: { email: user[:email], id: user[:id] }, status: 201, location: [:api, user]
      else
        render json: { errors: user.errors }, status: 422
      end
    else
      render json: { 'email' => ['has already been taken'] }, status: 422
    end
  end


  def update
  	user = current_user
    if user.valid_password? params[:old]
      user.password = params[:new]
      user.password_confirmation = params[:new_confirmation]
      if user.save
        render json: { email: user[:email] }, status: 200, location: [:api, user]
      else
        render json: { errors: user.errors }, status: 422
      end

    else
      render json: { errors: {'password' => ['Invalid password']}}, status: 422
    end
  end


  def destroy
  	current_user.destroy
  	head 204
	end


  def verify
    user = Trainer.find_by(auth_token: params['auth_token'])
    if user.nil?
      render status: 404
    elsif user.update_attribute(:confirmed, true)
      render "api/trainers/verify.html.erb"
    else
      render status: 500
    end
  end


  def reset
    user = Trainer.find_by(email: params[:email])
    if user.nil?
      render json: { errors: 'Invalid email' }, status: 422
    else
      random_string = (0...8).map { (65 + rand(26)).chr }.join
      user.password = random_string
      user.password_confirmation = random_string
      if user.save
        if (params[:email].end_with? "gmail.com") || (params[:email].end_with? "berkeley.edu")
          WelcomeMailer.reset_password_email(user, random_string).deliver_now
        end
        render json: { email: user[:email] }, status: 200, location: [:api, user]
      else
        render json: { errors: user.errors }, status: 422
      end
    end
  end

end
