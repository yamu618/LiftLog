class WorkoutSetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout_set, only: %i[edit update destroy]

  def edit; end

  def update
    if @set.update(set_params)
      redirect_to workout_path(@set.workout), notice: "セットを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    workout = @set.workout
    @set.destroy
    redirect_to workout_path(workout), notice: "セットを削除しました"
  end

  private

  def set_workout_set
    @set = current_user.workout_sets.find(params[:id])
  end

  def set_params
    params.require(:workout_set).permit(:weight, :reps, :duration, :distance)
  end
end
