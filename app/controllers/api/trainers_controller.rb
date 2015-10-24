class Api::TrainersController < ApplicationController
	before_action :authenticate_with_token!, only: [:update, :destroy]
	respond_to :json

	def show
		render json: Trainer.find(params[:id])
	end


	def create
    	user = Trainer.new(user_params)
    	if user.save
      		render json: user, status: 201, location: [:api, user]
    	else
     		render json: { errors: user.errors }, status: 422
    	end
  	end


  	def update
  		user = current_user

  		if user.update(user_params)
  			puts user.password
  			render json: user, status: 200, location: [:api, user]
  		else
  			render json: { errors: user.errors }, status: 422
  		end
  	end



  	def destroy
  		current_user.destroy
  		head 204
	end



  	private
   		def user_params
    		params.require(:trainer).permit(:email, :password, :password_confirmation)
    	end
end
