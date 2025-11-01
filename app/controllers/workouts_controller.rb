class WorkoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout, only: %i[destroy]
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @workouts = current_user.workouts.includes(exercise: :category, workout_sets: []).where(performed_on: @selected_date).order("categories.name, exercises.name")
  end

  def new
    @workout = current_user.workouts.new(performed_on: params[:date] || Date.today)
    @exercises = current_user.exercises.includes(:category)
  end

  def create
    @workout = current_user.workouts.new(workout_params)
    if @workout.save
      redirect_to workouts_path, notice: "ワークアウトを記録しました"
    else
      @exercises = current_user.exercises.includes(:category)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @workout_sets = @workout.workout_sets.order(:created_at)
    @workout_set = @workout.workout_sets.new
  end

  def destroy
    @workout.destroy
    redirect_to workouts_path, notice: "ワークアウトを削除しました", status: :see_other
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params:[id])
  end

  def workout_params
    params.requre(:workout).permit(:exercise_id, :performed_on)
  end
end
