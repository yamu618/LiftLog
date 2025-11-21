class Api::ExercisesController < ApplicationController
  def index
    query = params[:query]
    category_id = params[:category_id]

    # queryが空の場合、何も返さない
    return render json: [] if query.blank?

    exercises = current_user.exercises
                            .where(category_id: category_id)
                            .where("name LIKE ?", "#{query}%")
                            .order(:name)
                            .limit(10)

    render json: exercises.pluck(:name)
  end
end
