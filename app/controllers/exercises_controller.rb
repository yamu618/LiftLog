class ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise, only: %i[edit update destroy]

  def index
    @categories = Category.all
    @selected_category = params[:category_id].present? ? Category.find(params[:category_id]) : @categories.first
    @exercises = current_user.exercises.where(category: @selected_category)

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def create
  @exercise = current_user.exercises.new(exercise_params)
  
  if @exercise.save
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.append("exercises_list", partial: "exercise", locals: { exercise: @exercise }),
          turbo_stream.replace("exercise_form", partial: "form", locals: { exercise: Exercise.new })
        ]
      }
      format.html { redirect_to exercises_path, notice: "種目を追加しました" }
    end
  else
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "exercise_form",
          partial: "form",
          locals: { exercise: @exercise }
        )
      }
      format.html { render :new, status: :unprocessable_entity }
    end
  end
end

  def edit
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "exercise_#{@exercise.id}",
          partial: "form",
          locals: { exercise: @exercise }
        )
      }
      format.html
    end
  end

  def update
    if @exercise.update(exercise_params)
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "exercise_#{@exercise.id}",
            partial: "exercise",
            locals: { exercise: @exercise }
          )
        }
        format.html { redirect_to exercises_path, notice: "種目を更新しました"}
      end
    else
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "exercise_#{@exercise.id}",
            partial: "form",
            locals: { exercise: @exercise }
          )
        }
        format.html { render :edit, status: :unprocessable_entity}
      end
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
