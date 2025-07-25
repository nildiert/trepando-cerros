class TrainingPlansController < ApplicationController
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
    @athletes = current_user.trainees
    7.times { |i| @training_plan.training_plan_days.build(day: i) }
  end

  def create
    authorize! :manage, TrainingPlan
    @training_plan = current_user.training_plans.new(training_plan_params)
    @athletes = current_user.trainees
    if @training_plan.save
      redirect_to @training_plan, notice: 'Plan creado'
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
    params.require(:training_plan).permit(:name, :description, :athlete_id,
                                          training_plan_days_attributes: %i[id day workout_type])
  end
end
