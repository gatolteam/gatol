class Api::QuestionSetsController < ApplicationController
  before_action :authenticate_with_token!, :set_question_set, only: [:show, :edit, :update, :destroy]
  respond_to :json

  # Get all the QuestionSets belonging to a particular User
  # GET /question_sets
  def index
    user = current_user
    #if user.is_trainer?
      @question_sets = QuestionSet.where(trainer_id: user.id)
      render json: { id: user.id, question_sets: @question_sets.to_json(:include => :questions) }
  end

end