class Api::GamesController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :edit, :update, :destroy]
  respond_to :json

  # GET /games
  # GET /games.json
  def index
    user = current_user
    if user.is_trainer?
      games = Game.where(trainer_id: user.id)
      render json: {
        games: games
      }, status: 200
    else
      render json: {
        errors: ['user is not a trainer']
      }, status: 401
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    user = current_user
    if user.is_trainer?
      game = Game.find_by_id(params[:id])
      if !game.nil? && game.trainer_id == user.id
        render json: {
          game: game
        }, status: 200
      elsif game.nil?
        render json: {
          errors: ['game does not exist']
        }, status: 400
      else
        render json: {
          errors: ['trainer does not have access to this game']
        }, status: 401
      end
    else
      render json: {
        errors: ['user is not a trainer']
      }, status: 401
    end
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    user = current_user
    if user.is_trainer?
      @game = Game.new(game_params)
      begin 
        if @game.save!
          render json: {}, status: 200
          return
        end
      rescue ActiveRecord::RecordInvalid
        render json: {
          errors: @game.errors.full_messages
        }, status: 401
        return
      end
      render json: {
        errors: ['game could not be saved']
      }, status: 422
    else
      render json: {
          errors: ['user is not a trainer']
      }, status: 401
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    user = current_user
    game = Game.find(params[:id])
    if !game.nil? && game.trainer_id == user.id
      game.destroy
      render json: {}, status: 200
    elsif game.nil?
      render json: {
        errors: ['game does not exist']
      }, status: 400
    else
      render json: {
        errors: ['trainer does not have access to this game']
      }, status: 401
    end
  end

  # POST api/games/:id/enroll
  def enroll
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    def game_params
      params.require(:game).permit(:name, :description, :trainer_id, :question_set_id, :game_template_id)
    end

    def errors(i)
      case i
      when 0
        render json: {
          errors: ['user is not a trainer']
        }, status: 401
      when 1
        render json: {
          errors: ['trainer does not have access to this game']
        }, status: 401
      when 2
        render json: {
          errors: ['game does not exist']
        }, status: 400
    else
      end
    end
end
