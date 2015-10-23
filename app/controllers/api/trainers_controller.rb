class Api::TrainersController < ApplicationController
	respond_to :json

	def show
		render json: Trainer.find(params[:id])
	end
end
