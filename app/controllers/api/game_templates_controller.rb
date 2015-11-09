class Api::GameTemplatesController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :edit, :update, :destroy]
  respond_to :json
  # GET /game_templates
  # GET /game_templates.json
  def index
    user = current_user
    if user.is_trainer?
      @game_templates = GameTemplate.all
      render json: {
        status: 200,
        templates: @game_templates
      }
    else
      render json: {
        status: 401,
        errors: ['access denied to students']
      }
    end
  end

  # GET /game_templates/1
  # GET /game_templates/1.json
  def show
    user = current_user
    if user.is_trainer?
      template = GameTemplate.find_by_id(params[:id])
      if !template.nil?
        render json: {
          status: 200,
          template: template
        }
      else
        render json: {
          status: 400,
          errors: ['game template does not exist']
        }
      end
    else
      render json: {
        status: 401,
        errors: ['access denied to students']
      }
    end
  end

  # GET /game_templates/new
  #def new
  #  @game_template = GameTemplate.new
  #end

  # GET /game_templates/1/edit
  #def edit
  #end

  # POST /game_templates
  # POST /game_templates.json
  def create
    @template = GameTemplate.new(game_template_params)
    if @template.save
      render json: {
        status: 200
      }
    else
      render json: {
        status: 401
      }
    end
  end

  # DELETE /game_templates/1
  # DELETE /game_templates/1.json
  def destroy
    template = GameTemplate.find(params[:id])
    if !template.nil?
      template.destroy
      render json: {
        status: 200
      }
    else
      render json: {
        status: 400,
        errors: ['game template does not exist']
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_template
      @game_template = GameTemplate.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_template_params
      params[:game_template]
    end
end
