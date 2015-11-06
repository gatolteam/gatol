class Api::GameTemplatesController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :edit, :update, :destroy]
  respond_to :json
  # GET /game_templates
  # GET /game_templates.json
  def index
    @game_templates = GameTemplate.all
  end

  # GET /game_templates/1
  # GET /game_templates/1.json
  def show
  end

  # GET /game_templates/new
  def new
    @game_template = GameTemplate.new
  end

  # GET /game_templates/1/edit
  def edit
  end

  # POST /game_templates
  # POST /game_templates.json
  def create
    @game_template = GameTemplate.new(game_template_params)

    respond_to do |format|
      if @game_template.save
        format.html { redirect_to @game_template, notice: 'Game template was successfully created.' }
        format.json { render :show, status: :created, location: @game_template }
      else
        format.html { render :new }
        format.json { render json: @game_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_templates/1
  # PATCH/PUT /game_templates/1.json
  def update
    respond_to do |format|
      if @game_template.update(game_template_params)
        format.html { redirect_to @game_template, notice: 'Game template was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_template }
      else
        format.html { render :edit }
        format.json { render json: @game_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_templates/1
  # DELETE /game_templates/1.json
  def destroy
    @game_template.destroy
    respond_to do |format|
      format.html { redirect_to game_templates_url, notice: 'Game template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_template
      @game_template = GameTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_template_params
      params[:game_template]
    end
end
