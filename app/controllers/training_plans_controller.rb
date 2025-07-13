class TrainingPlansController < ApplicationController
  before_action :authenticate_user
  before_action :set_training_plan, only: [:show]

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
  end

  def create
    authorize! :manage, TrainingPlan
    @training_plan = current_user.training_plans.new(training_plan_params)
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

  def training_plan_params
    params.require(:training_plan).permit(:name, :description)
  end
end
