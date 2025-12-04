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
      best_amount = @set.best_updated_amount
      best_type = @set.best_updated_type

      flash[:personal_best] = { amount: best_amount, type: best_type } if best_amount.present?
    else
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today.beginning_of_month
      @workout = @set.workout

      respond_to do |format|
        format.turbo_stream { render :update_failed, status: :unprocessable_entity }
      end
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
