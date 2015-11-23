class Api::GamesController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :update, :destroy]
  respond_to :json

  # GET /games
  def index
    user = current_user
    if user.is_trainer?
      games = Game.where(trainer_id: user.id)
      render json: {
        games: games
      }, status: 200
    else
      games = games_for_students(user)
      render json: {
        games: games
      }, status: 200
    end

  end

  # GET /games/1
  def show
    user = current_user
    game = Game.find_by_id(params[:id])
    if game.nil?
      render json: {
          errors: ['game does not exist']
        }, status: 400
    else
      if user.is_trainer?
        if game.trainer_id == user.id
          render json: {
            game: game
          }, status: 200
        else
          render json: {
            errors: ['trainer does not have access to this game']
          }, status: 401
        end
      else
        enrolled = games_for_students(user, game.id)
        if enrolled.nil?
          render json: {
            errors: ['user does not have access to this game']
          }, status: 401
        else
          render json: {
              game: enrolled
            }, status: 200
        end
      end
    end
  end

  # POST /games
  def create
    user = current_user
    if user.is_trainer?
      @game = Game.new(game_params)
      @game.trainer_id = user.id
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
  def destroy
    user = current_user
    if user.is_trainer?
      game = Game.find_by_id(params[:id])
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
    else
      render json: {
          errors: ['user is not a trainer']
      }, status: 401
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find_by_id(params[:id])
    end

    def game_params
      params.require(:game).permit(:name, :description, :trainer_id, :question_set_id, :game_template_id)
    end

    def games_for_students_json(g)
      return g.to_json(:only => [:name, :description])
    end

    def games_for_students(user, gid=nil)
      if gid.nil?
        return GameEnrollment.joins(:game).select('games.id as id, games.name as name, games.description as description').where(student_email: user.email)
      else
        return GameEnrollment.joins(:game).select('games.id as id, games.name as name, games.description as description').where(student_email: user.email, game_id: gid).first
      end
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
