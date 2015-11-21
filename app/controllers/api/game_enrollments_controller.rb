class Api::GameEnrollmentsController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :index, :delete, :create]
  respond_to :json


  # GET /api/game_enrollment/1
  # id = game_id of the game
  def show
  	user = current_user

  	user = current_user
  	if !user.is_trainer?
  	  render json: { errors: ['user is not a trainer'] }, status: 401
  	  return
  	end

  	game = Game.find_by_id(params[:id])
  	if game.nil? || game.trainer_id != user.id
  	  render json: { errors: ['trainer does not have access to this game'] }, status: 401
  	else
  	  enrollments = GameEnrollment.where(game_id: params[:id])
  	  render json: { game_enrollments: enrollments }, status: 200
  	end
  end


  # GET /api/game_enrollment
  def index
    user = current_user

    if user.is_trainer?
      enrollments = GameEnrollment.where(trainer_id: user.id)
      render json: { game_enrollments: enrollments }, status: 200
    else
      enrollments = GameEnrollment.where(student_email: user.email)
      render json: { game_enrollments: enrollments }, status: 200
    end
  end


  # POST /api/game_enrollment
  def create
  	user = current_user
  	if !user.is_trainer?
  	  render json: { errors: ['user is not a trainer'] }, status: 401
  	  return
  	end


  	game = Game.find_by_id(game_enrollment_params[:game_id])

  	if game.nil? || game.trainer_id != user.id
  	  render json: { errors: ['trainer does not have access to this game'] }, status: 401
  	  return
  	end

  	newEnrollment = GameEnrollment.new(game_enrollment_params)
  	newEnrollment.trainer_id = user.id
  	student = Student.find_by(email: game_enrollment_params[:student_email])
  	if student.nil?
  		newEnrollment.registered = false
  	else
  		newEnrollment.registered = true
  	end

  	if newEnrollment.save
  	  render json: newEnrollment, status: 200
  	else
  	  render json: { errors: ['Unprocessible entity'] }, status: 422
  	end

  end


  # DELETE /api/game_enrollment/1
  # the id of each entry in the enrollment database. each enrollment has its own id. It is provided in the show method
  def destroy
  	user = current_user
  	if !user.is_trainer?
  	  render json: { errors: ['user is not a trainer'] }, status: 401
  	  return
  	end

  	gameEnrollmentInstance = GameEnrollment.find_by_id(params[:id])
  	if gameEnrollmentInstance.trainer_id == user.id
  	  gameEnrollmentInstance.destroy
      head 204
  	else
  	  render json: { errors: ['trainer does not have access to this game'] }, status: 401
  	end

  end




  private

    def game_enrollment_params
      params.require(:game_enrollment).permit(:game_id, :student_email)
    end














end
