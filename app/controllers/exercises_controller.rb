class ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise, only: [:update, :destroy]

  def index
    @categories = Category.all
    @selected_category = params[:category_id].present? ? Category.find(params[:category_id]) : nil

    if @selected_category
      @exercises = current_user.exercises.where(category: @selected_category)
    else
      @exercises = current_user.exercises
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @exercise = current_user.exercises.new(exercise_params)
    if @exercise.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to exercises_path, notice: "種目を追加しました" }
      end
    else
      render turbo_stream: turbo_stream.replace(
        "exercise_form",
        partial: "form",
        locals: { exercise: @exercise }
      )
    end
  end

  def update
    @exercise.update(exercise_params)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to exercises_path }
    end
  end

  def destroy
    @exercise.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to exercises_path }
    end
  end

  private

  def set_exercise
    @exercise = current_user.exercises.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:name, :category_id)
  end
end
