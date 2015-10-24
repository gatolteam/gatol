class Api::SessionsController < ApplicationController

	def create
		user_password = params[:session][:password]
		user_email = params[:session][:email]
		user = user_email.present? && Trainer.find_by(email: user_email)
		if user.nil?
			user = user_email.present? && Student.find_by(email: user_email)
		end

		if user.valid_password? user_password
			sign_in user, store: false
			user.generate_authentication_token!
			user.save
			render json: user, status: 200, location: [:api, user]
		else
			render json: { errors: "Invalid email or password" }, status: 422
		end

	end




	def destroy
		user = Trainer.find_by(auth_token: params[:id])
		if user.nil?
			user = Student.find_by(auth_token: params[:id])
		end
		user.generate_authentication_token!
		user.save
		head 204
	end







end
