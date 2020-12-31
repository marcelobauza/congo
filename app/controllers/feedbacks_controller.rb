class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end
  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.properties = params[:feedback].as_json
    @feedback.layer_type = params[:feedback]['layer_type']

    respond_to do |format|
      if @feedback.save
        FeedbackMailer.with(feedback: @feedback).new_feedback_email.deliver_later
        format.js
        format.html { redirect_to @feedback, notice: 'Feedback was successfully created.' }
        format.json { render :show, status: :created, location: @feedback }
      else
        format.html { render :new }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:properties, :layer_type, :row_id).merge(user_id: current_user.id)
    end
end
