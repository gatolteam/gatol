class Api::GameInstancesController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :edit, :update, :destroy]
  respond_to :json
  # GET /game_instances
  # GET /game_instances.json
  def index
    user = current_user
    #if user is student
    game_instances = GameInstance.where(student_id: user.id)
    render json: {
      status: 200,
      games: game_instances
    }
  end

  # GET /game_instances/1
  # GET /game_instances/1.json
  def show
    user = current_user
    game_instance = GameInstance.find(params[:id])
    if !game_instance.nil? && game_instance.student_id == user.id
      render json: {
        status: 200,
        game_instance: game_instance
      }
    elsif game_instance.nil?
      render json: {
        status: 400,
        errors: ['game instance does not exist']
      }  
    else
      render json: {
        status: 401,
        errors: ['trainer does not have access to this game instance']
      }
    end
  end

  # GET /game_instances/new
  def new
    @game_instance = GameInstance.new
  end

  # GET /game_instances/1/edit
  def edit
  end

  # POST /game_instances
  # POST /game_instances.json
  def create
    @game_instance = GameInstance.new(game_instance_params)
    if @game_instance.save
      render json: {
        status: 200
      }
    else
      render json: {
        status: 401
      }
    end
  end

  # PATCH/PUT /game_instances/1
  # PATCH/PUT /game_instances/1.json
  def update
  end

  # DELETE /game_instances/1
  # DELETE /game_instances/1.json
  def destroy
    user = current_user
    game = GameInstance.find(params[:id])
    if !game.nil? && game.student_id == user.id
      game.destroy
      render json: {
        status: 200
      }
    elsif game.nil?
      render json: {
        status: 400,
        errors: ['game instance does not exist']
      }
    else
      render json: {
        status: 401,
        errors: ['student does not have access to this game instance']
      }
    end
  end


  # View Games (Student): views all games that student is playing
  def get_active
  end

  # View Player Statistics for all games (Student)
  def get_stats_all
  end

  # View Player Statistics for specific game (Student)
  def get_stats_game
  end

  # View Game Statistics for specific player (Trainer)
  def get_stats_player
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_instance
      @game_instance = GameInstance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_instance_params
      params[:game_instance]
    end
end
