class WorkoutSetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout

  def create
    @workout_set = @workout.workout_sets.new(workout_set_params)
    if @workout_set.save
      redirect_to workout_path(@workout), notice: "セットを追加しました", status: :see_other
    else
      @workout_sets = @workout.workout_sets.order(:created_at)
      render "workouts/show", status: :unprocessable_entity
    end
  end

  def destroy
    @workout_set = @workout.workout_sets.find(params[:id])
    @workout_set.destroy
    redirect_to workout_path(@workout), notice: "セットを削除しました", status: :see_other
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params[:workout_id])
  end

  def workout_set_params
    params.require(:workout_set).permit(:weight, :reps)
  end
end
