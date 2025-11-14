class WorkoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout, only: %i[show destroy new_set create_set]
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @selected_date = params[:date].present? ? Date.parse(params[:date]) : Time.zone.today
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : @selected_date.beginning_of_month
    @workouts = if user_signed_in?
                  current_user.workouts
                    .includes(exercise: :category, workout_sets: [])
                    .where(performed_on: @selected_date)
                    .order(created_at: :asc)
                else
                  []
                end
    @all_workouts = user_signed_in? ? current_user.workouts : []
    @workout_title = user_signed_in? ? "#{current_user.username}のワークアウト" : "ゲストのワークアウト"
  end

  def new
    @workout = current_user.workouts.new(performed_on: params[:date] || Time.zone.today)
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today.beginning_of_month
    @categories = Category.order(:id)
    @selected_category = params[:category_id].present? ? Category.find(params[:category_id]) : @categories.first
    @exercises = current_user.exercises.where(category: @selected_category).order(:name)
  end

  def create
    @workout = current_user.workouts.new(workout_params)
    if @workout.save
      redirect_to workouts_path(date: @workout.performed_on), notice: "ワークアウトを作成しました"
    else
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today.beginning_of_month
      @categories = Category.order(:id)
      @selected_category = params[:category_id].present? ? Category.find(params[:category_id]) : @categories.first
      @exercises = current_user.exercises.where(category: @selected_category).order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today.beginning_of_month
    @exercise_name = @workout.exercise.name
    @sets = @workout.workout_sets.order(:id)
  end

  def destroy
    @workout.destroy

    redirect_to workouts_path(date: @workout.performed_on), notice: "ワークアウトを削除しました", status: :see_other
  end

  def show
    @sets = @workout.workout_sets.order(:id)
  end

  def new_set
    @sets = [@workout.workout_sets.build(weight: 0, reps: 0, duration: 0, distance: 0)]
  end

  def create_set
    @sets = []
    success = true

    if params[:workout_sets].present?
      params[:workout_sets].each do |_i, set_attr|
        permitted = set_attr.permit(:weight, :reps, :duration, :distance)
        next if permitted.values.all?(&:blank?)

        set = @workout.workout_sets.build(permitted)
        success &&= set.valid?
        @sets << set
      end
    end

    if success && @sets.any?
      @sets.each(&:save!)
      redirect_to workout_path(@workout), notice: "#{@sets.size}件のセットを追加しました"
    else
      flash.now[:alert] = "エラーが発生しました。重量と回数は0以上で入力してください。"
      @sets = [@workout.workout_sets.build(weight: 0, reps: 0, duration: 0, distance: 0)] if @sets.blank?
      render :new_set, status: :unprocessable_entity
    end
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params[:id])
  end

  def workout_params
    params.require(:workout).permit(:exercise_id, :performed_on)
  end
end
