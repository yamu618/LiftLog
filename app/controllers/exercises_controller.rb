class ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise, only: %i[edit update destroy]

  def index
    @categories = Category.all
    @selected_category = params[:category_id].present? ? Category.find(params[:category_id]) : @categories.first
    @exercises = current_user.exercises.where(category: @selected_category).order(:name)
  end

  def create
    @exercise = current_user.exercises.new(exercise_params)

    if @exercise.save
      redirect_to exercises_path(category_id: @exercise.category_id), notice: "種目を追加しました"
    else
      flash[:alert] = error_message(@exercise)
      redirect_to exercises_path(category_id: @exercise.category_id)
    end
  end

  def edit
    render partial: "form", locals: { exercise: @exercise }
  end

  def update
    if @exercise.update(exercise_params)
      render partial: "exercise", locals: { exercise: @exercise }
    else
      flash.now[:alert] = error_message(@exercise)
      render partial: "form", locals: { exercise: @exercise }, status: :unprocessable_entity
    end
  end

  def destroy
    @exercise.destroy
    flash.now.notice = "種目を削除しました"
  end

  private

  def set_exercise
    @exercise = current_user.exercises.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:name, :category_id)
  end

  def error_message(exercise)
    if exercise.errors.full_messages.include?("種目名を入力してください")
      "種目名を入力してください"
    elsif exercise.errors.full_messages.include?("種目名はすでに存在します")
      "その種目は既に存在しています"
    else
      "種目を保存できませんでした"
    end
  end
end
