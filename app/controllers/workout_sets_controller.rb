class WorkoutSetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout_set, only: %i[edit update destroy]

  def edit
    @workout = @set.workout
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today.beginning_of_month
    render partial: "workout_sets/form", locals: { set: @set }
  end

  def update
    if @set.update(set_params)
      render partial: "workout_sets/set", locals: { set: @set }
    else
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today.beginning_of_month
      @workout = @set.workout
      render partial: "workout_sets/form", locals: { set: @set }, status: :unprocessable_entity
    end
  end

  def destroy
    @set.workout
    @set.destroy
    flash.now.notice = "セットを削除しました。"
  end

  private

  def set_workout_set
    @set = current_user.workout_sets.find(params[:id])
  end

  def set_params
    params.require(:workout_set).permit(:weight, :reps, :duration, :distance)
  end
end
