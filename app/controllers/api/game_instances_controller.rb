class Api::GameInstancesController < ApplicationController
  before_action :set_game_instance, only: [:show, :edit, :update, :destroy]

  # GET /game_instances
  # GET /game_instances.json
  def index
    @game_instances = GameInstance.all
  end

  # GET /game_instances/1
  # GET /game_instances/1.json
  def show
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

    respond_to do |format|
      if @game_instance.save
        format.html { redirect_to @game_instance, notice: 'Game instance was successfully created.' }
        format.json { render :show, status: :created, location: @game_instance }
      else
        format.html { render :new }
        format.json { render json: @game_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_instances/1
  # PATCH/PUT /game_instances/1.json
  def update
    respond_to do |format|
      if @game_instance.update(game_instance_params)
        format.html { redirect_to @game_instance, notice: 'Game instance was successfully updated.' }
        format.json { render :show, status: :ok, location: @game_instance }
      else
        format.html { render :edit }
        format.json { render json: @game_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_instances/1
  # DELETE /game_instances/1.json
  def destroy
    @game_instance.destroy
    respond_to do |format|
      format.html { redirect_to game_instances_url, notice: 'Game instance was successfully destroyed.' }
      format.json { head :no_content }
    end
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
