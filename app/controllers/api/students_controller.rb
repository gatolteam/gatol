class Api::StudentsController < ApplicationController

	before_action :authenticate_with_token!, only: [:update, :destroy]
	respond_to :json

	def show
		render json: Student.find(params[:id])
	end


	def create
    	user = Student.new(user_params)
    	if user.save
      		render json: user, status: 201, location: [:api, user]
    	else
     		render json: { errors: user.errors }, status: 422
    	end
  	end


  	def update
  		# user = Student.find(params[:id])
  		user = current_user

  		if user.update(user_params)
  			puts user.password
  			render json: user, status: 200, location: [:api, user]
  		else
  			render json: { errors: user.errors }, status: 422
  		end
  	end



  	def destroy
  		# user = Student.find(params[:id])
  		# user.destroy
  		current_user.destroy
  		head 204
	end



  	private
   		def user_params
    		params.require(:student).permit(:email, :password, :password_confirmation)
    	end
end
