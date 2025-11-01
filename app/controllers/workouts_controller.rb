class WorkoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout, only: %i[edit update destroy]
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    selected_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @workouts = current_user.workouts.includes(:exercise, exercise: :category).order(performed_on: :desc)
  end

  def new
    @workout = current_user.workouts.new
    @categories = Category.all
    @exercises = Exercise.where(user: current_user)
  end

  def create
    @workout = current_user.workouts.new(workout_params)
    if @workout.save
      redirect_to workouts_path, notice: "ワークアウトを記録しました"
    else
      @categories = Category.all
      @exercises = Exercise.where(user: current_user)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.all
    @exercises = Exercise.where(user: current_user)
  end

  def update
    @workout.assign_attributes(workout_params)

    if @workout.save
      redirect_to workouts_path, notice: "ワークアウトを更新しました"
    else
      @categories = Category.all
      @exercises = Exercise.where(user: current_user)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workout.destroy
    redirect_to workouts_path, notice: "ワークアウトを削除しました", status: :see_other
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params:id)
  end

  def workout_params
    params.requre(:workout).permit(:exercise_id, :weight, :reps, :performed_on)
  end
end
