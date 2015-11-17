class Api::GameInstancesController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :edit, :update, :destroy]
  respond_to :json
  # GET /game_instances
  # GET /game_instances.json
  def index
    user = current_user
    if user.is_trainer?
      render json: {
        #DO THIS
        #history: list of tuples (email, high_score)

        }, status: 200
    else
      get_stats_all
    end
  end

  # GET /game_instances/1
  # GET /game_instances/1.json
  def show
    user = current_user
    game_instance = GameInstance.find_by_id(params[:id])
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
        errors: ['user does not have access to this game instance']
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
    game_instance = GameInstance.new(game_instance_params)
    if game_instance.save
      game = game_instance.game
      game 
      render json: {
          game_id: @game_instance.id,
          game_description: game.description,
          question_set_id: game.question_set_id,
          template_id: game.game_template_id
        }, status: 200
    else
      render json: {}, status: 401
    end
  end

  # PATCH/PUT /game_instances/1
  # PATCH/PUT /game_instances/1.json
  def update
    user = current_user
    newScore = params[:score]
    q = params[:lastQuestion]
    game_instance = GameInstance.find_by_id(params[:id])
    if !game_instance.nil? && game_instance.student_id == user.id
      if game_instance.update(newScore, q) 
        render json: {
        }, status: 200
      else
        render json: {
          errors: ['update could not be completed']
        }, status: 500
      end
    elsif game_instance.nil?
      render json: {
        errors: ['game instance does not exist']
      }, status: 400 
    else
      render json: {
        errors: ['user does not have access to this game instance']
      }, status: 401
    end
  end

  # DELETE /game_instances/1
  # DELETE /game_instances/1.json
  def destroy
    user = current_user
    game = GameInstance.find_by_id(params[:id])
    if !game.nil? && game.student_id == user.id
      game.destroy
      render json: {}, status: 200
    elsif game.nil?
      render json: {
        errors: ['game instance does not exist']
      }, status: 400
    else
      render json: {
        errors: ['student does not have access to this game instance']
      }, status: 401
    end
  end


  # View Games (Student): views all games that student is playing
  def get_active
    user = current_user
    active = GameInstance.where(student_id: user.id, active: true)
    render json: {
      games: active
    }, status: 200
  end

  # View Player Statistics for all games (Student)
  def get_stats_all
    user = current_user
    all = GameInstance.where(student_id: user.id)
    render json: {
      games: all
      #DO THIS
      #history: (date, score)
      #ranking: list of 10 tuples (email, high_score)
    }
  end

  # View Player Statistics for specific game (Student)
  def get_stats_game
    user = current_user
    gameid = params[:game_id]
    stats = GameInstance.where(student_id: user.id, game_id: gameid)
    render json: {
      game_stats: stats
    }
  end

  # View Game Statistics for specific player (Trainer)
  def get_stats_player
    user = current_user
    pemail = params[:student_email]
    gameid = params[:game_id]
    g = Game.find_by_id(gameid)
    if g.nil?
      render json: {
        errors: ['no game exists for this game id']
      }, status: 404
      return
    end

    if user.is_trainer? && g.trainer_id == user.id
      pid = Student.find_by email: pemail
      if pid.nil?
        render json: {
          errors: ['no student found for given email']
        }, status: 404
      #elsif student is enrolled in this game
      else
        stats = GameInstance.where(game_id: gameid, student_id: pid)
        render json: {
          game_stats: stats
          #DO THIS
          #history: list of tuples (date, score)
        }, status: 200
      end
    elsif user.is_trainer?
        render json: {
          errors: ['trainer does not have access to this game data']
        }, status: 401
    elsif email == user.email
      get_stats_game
    else
      render json: {
          errors: ['student does not have access to player data']
        }, status: 401
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_instance
      @game_instance = GameInstance.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_instance_params
      params[:game_instance]
    end
end
