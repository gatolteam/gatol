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
        status: 200,
        games: games
      }
    else
      render json: {
        status: 401,
        errors: ['user is not a trainer']
      }
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
          status: 200,
          game: game
        }
      elsif game.nil?
        render json: {
          status: 400,
          errors: ['game does not exist']
        }  
      else
        render json: {
          status: 401,
          errors: ['trainer does not have access to this game']
        }
      end
    else
      render json: {
        status: 401,
        errors: ['user is not a trainer']
      }
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
      if @game.save
        render json: {
          status: 200
        }
      else
        render json: {
          status: 401,
          errors: ['game could not be saved']
        }
      end
    else
      render json: {
          status: 401,
          errors: ['user is not a trainer']
      }
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    user = current_user
    game = Game.find(params[:id])
    if !game.nil? && game.trainer_id == user.id
      game.destroy
      render json: {
        status: 200
      }
    elsif game.nil?
      render json: {
        status: 400,
        errors: ['game does not exist']
      }
    else
      render json: {
        status: 401,
        errors: ['trainer does not have access to this game']
      }
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
      params[:game]
    end

    def errors(i)
      case i
      when 0
        render json: {
          status: 401,
          errors: ['user is not a trainer']
        }
      when 1
        render json: {
          status: 401,
          errors: ['trainer does not have access to this game']
        }
      when 2
        render json: {
          status: 400,
          errors: ['game does not exist']
        }
    else
      end
    end
end
