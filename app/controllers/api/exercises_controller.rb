class Api::ExercisesController < ApplicationController
  before_action :authenticate_user!

  def index
    query = params[:query].to_s
    category_id = params[:category_id]

    return render json: [] if query.blank?

    query_kana = query.tr('ぁ-ん', 'ァ-ン')

    exercises = current_user.exercises
                            .where(category_id: category_id)
                            .where("name LIKE ?", "#{query_kana}%")
                            .order(:name)
                            .limit(10)

    render json: exercises.pluck(:name)
  end
end
