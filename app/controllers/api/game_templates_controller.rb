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
        templates: @game_templates
      }, status: 200
    else
      render json: {
        errors: ['access denied to students']
      }, status: 401
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
          template: template
        }, status: 200
      else
        render json: {
          errors: ['game template does not exist']
        }, status: 400
      end
    else
      render json: {
        errors: ['access denied to students']
      }, status: 401
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
    name = params[:name]
    desc = params[:description]
    @template = GameTemplate.new(name: name, description: desc)
    if @template.save
      render json: {}, status: 200
    else
      render json: {}, status: 401
    end
  end

  # DELETE /game_templates/1
  # DELETE /game_templates/1.json
  def destroy
    template = GameTemplate.find(params[:id])
    if !template.nil?
      template.destroy
      render json: {}, status: 200
    else
      render json: {
        errors: ['game template does not exist']
      }, status: 400
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_template
      @game_template = GameTemplate.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_template_params
      params.require(:game_template).permit(:name, :description)
    end
end
