class TrainingPlansController < ApplicationController
  layout 'internal'
  before_action :authenticate_user
  before_action :set_training_plan, only: [:show]
  before_action :set_athlete

  def index
    authorize! :manage, TrainingPlan
    @training_plans = current_user.training_plans
  end

  def show
    authorize! :manage, TrainingPlan
  end

  def new
    authorize! :manage, TrainingPlan
    @training_plan = current_user.training_plans.new
    if params[:athlete_id].present?
      @training_plan.athlete_id = params[:athlete_id]
      @athletes = []
    else
      @athletes = current_user.trainees
    end
    @training_plan.start_date = Date.current.beginning_of_week(:monday)
    @training_plan.end_date = @training_plan.start_date.end_of_week(:sunday)
    TrainingPlanDay::DAYS_OF_WEEK.each_index do |i|
      # initialize every day as rest
      @training_plan.training_plan_days.build(
        day: i,
        workout_type: :rest,
        activity_phase: :rest
      )
    end
  end

  def create
    authorize! :manage, TrainingPlan
    @training_plan = current_user.training_plans.new(training_plan_params)
    @athletes = current_user.trainees
    if @training_plan.save
      if @training_plan.athlete_id
        redirect_to profile_path(@training_plan.athlete_id), notice: 'Plan creado'
      else
        redirect_to @training_plan, notice: 'Plan creado'
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_training_plan
    @training_plan = current_user.training_plans.find(params[:id])
  end

  def set_athlete
    @athlete = fetch_athlete(params[:athlete_id])
  end

  def fetch_athlete(id = nil)
    token = session[:strava_token] || ENV['STRAVA_ACCESS_TOKEN']
    client = StravaClient.new(access_token: token)
    if id.present? && current_athlete_id.present? && id.to_s != current_athlete_id.to_s
      client.athlete(id)
    else
      client.athlete
    end
  rescue StandardError
    nil
  end

  def training_plan_params
    params.require(:training_plan).permit(
      :name,
      :description,
      :start_date,
      :end_date,
      :athlete_id,
      training_plan_days_attributes: %i[id day workout_type activity_phase _destroy]
    )
  end
end
