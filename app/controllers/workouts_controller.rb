class WorkoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout, only: %i[show destroy new_set create_set]
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @selected_date = params[:date].present? ? Date.parse(params[:date]) : Time.zone.today
    @workouts = if user_signed_in?
                  current_user.workouts
                    .includes(exercise: :category, workout_sets: [])
                    .where(performed_on: @selected_date)
                    .order(created_at: :asc)
                else
                  []
                end
    @all_workouts = user_signed_in? ? current_user.workouts : []
    @workout_title = user_signed_in? ? "#{current_user.username}のワークアウト" : "LiftLogへようこそ！"
  end

  def new
    @workout = current_user.workouts.new(performed_on: params[:date] || Time.zone.today)
    @exercises = current_user.exercises.includes(:category)
    @categories = Category.order(:id)
  end

  def create
    @workout = current_user.workouts.new(workout_params)
    if @workout.save
      redirect_to workouts_path(date: @workout.performed_on), notice: "ワークアウトを作成しました"
    else
      @exercises = current_user.exercises.includes(:category)
      @categories = Category.order(:id)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @exercise_name = @workout.exercise.name
    @sets = @workout.workout_sets.order(:id)
  end

  def destroy
    @workout.destroy
    redirect_to workouts_path(date: @workout.performed_on), notice: "ワークアウトを削除しました", status: :see_other
  end

  def new_set
    @set = @workout.workout_sets.new(weight: 0, reps: 0)
  end

  def create_set
    @set = @workout.workout_sets.new(set_params)
    if @set.save
      redirect_to workout_path(@workout), notice: "セットを追加しました"
    else
      render :new_set, status: :unprocessable_entity
    end
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params[:id])
  end

  def workout_params
    params.require(:workout).permit(:exercise_id, :performed_on)
  end

  def set_params
    params.require(:workout_set).permit(:weight, :reps, :duration, :distance)
  end
end
