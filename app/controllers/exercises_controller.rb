class ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise, only: %i[edit update destroy]

  def index
    @categories = Category.all
    @selected_category = params[:category_id].present? ? Category.find(params[:category_id]) : @categories.first
    @exercises = current_user.exercises.where(category: @selected_category)
  end

  def create
    @exercise = current_user.exercises.new(exercise_params)

    if @exercise.save
      redirect_to exercises_path(category_id: @exercise.category_id), notice: "種目を追加しました"
    else
      redirect_to exercises_path(category_id: @exercise.category_id), alert: "種目名を入力してください"
    end
  end

  def edit; end

  def update
    if @exercise.update(exercise_params)
      redirect_to exercises_path(category_id: @exercise.category_id), notice: "種目を更新しました"
    else
      flash.now[:alert] = "種目名を入力してください"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @exercise.destroy

    redirect_to exercises_path(category_id: @exercise.category_id), notice: "種目を削除しました"
  end

  private

  def set_exercise
    @exercise = current_user.exercises.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:name, :category_id)
  end
end
