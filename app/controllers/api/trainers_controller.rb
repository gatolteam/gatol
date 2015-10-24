class Api::TrainersController < ApplicationController
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


  	def destroy
  		user = Trainer.find(params[:id])
  		user.destroy
  		head 204
	end



  	private
   		def user_params
    		params.require(:trainer).permit(:email, :password, :password_confirmation)
    	end
end
