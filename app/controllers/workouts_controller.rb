class WorkoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout, only: %i[show destroy new_set create_set copy_previous_sets]
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
      check_training_days_milestone

      redirect_to workouts_path(date: @workout.performed_on, start_date: params[:start_date]), notice: "ワークアウトを作成しました"
    else
      @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today.beginning_of_month
      @categories = Category.order(:id)
      @selected_category = params[:category_id].present? ? Category.find(params[:category_id]) : @categories.first
      @exercises = current_user.exercises.where(category: @selected_category).order(:name)
      flash.now[:alert] = "種目を選択してください。"
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
    flash.now.notice = "ワークアウトを削除しました。"
  end

  def new_set
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today.beginning_of_month
    @sets = [@workout.workout_sets.build(weight: 0, reps: 0, duration: 0, distance: 0)]
  end

  def create_set
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today.beginning_of_month
    @sets = []
    success = true

    exercise = @workout.exercise
    previous_best_weight = exercise.best_weight || 0
    previous_best_distance = exercise.best_distance || 0

    if params[:workout_sets].present?
      params[:workout_sets].each_value do |set_attr|
        permitted = set_attr.permit(:weight, :reps, :duration, :distance)
        next if permitted.values.all?(&:blank?)

        set = @workout.workout_sets.build(permitted)
        success &&= set.valid?
        @sets << set
      end
    end

    if success && @sets.any?
      @sets.each(&:save!)

      amount, type = calculate_and_apply_best_for_workout(
        @workout,
        previous_best_weight: previous_best_weight,
        previous_best_distance: previous_best_distance
      )

      flash[:personal_best_create] = { amount: amount, type: type } if amount.present?

      redirect_to workout_path(@workout, date: params[:date], start_date: params[:start_date]), notice: "#{@sets.size}件のセットを追加しました"
    else
      flash.now[:alert] = "重量と回数は0以上で入力してください。"
      @sets = [@workout.workout_sets.build(weight: 0, reps: 0, duration: 0, distance: 0)] if @sets.blank?
      render :new_set, status: :unprocessable_entity
    end
  end

  def copy_previous_sets
    previous_workout = Workout.where(user_id: @workout.user_id, exercise_id: @workout.exercise_id)
      .where("performed_on < ?", @workout.performed_on)
      .order(performed_on: :desc)
      .first

    if previous_workout.nil?
      redirect_to workout_path(@workout, date: params[:date], start_date: params[:start_date]), alert: "前回の記録がありませんでした。"
    else
      previous_workout.workout_sets.each do |set|
        @workout.workout_sets.create!(
          weight: set.weight,
          reps: set.reps,
          duration: set.duration,
          distance: set.distance
        )
      end
      redirect_to workout_path(@workout, date: params[:date], start_date: params[:start_date]), notice: "前回の記録をコピーしました。"
    end
  end

  private

  def set_workout
    @workout = current_user.workouts.find(params[:id])
  end

  def workout_params
    params.require(:workout).permit(:exercise_id, :performed_on)
  end

  def check_training_days_milestone
    todays_workouts_count = current_user.workouts.where(performed_on: @workout.performed_on).count
    return if todays_workouts_count > 1

    total_days = current_user.workouts.select(:performed_on).distinct.count

    if total_days >= 365 && (total_days % 365).zero?
      flash[:training_milestone] = milestone_message(total_days)
      return
    end

    milestones = [1, 10, 30, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900,
                  950, 1000]

    flash[:training_milestone] = milestone_message(total_days) if milestones.include?(total_days)
  end

  def milestone_message(days)
    if days == 1
      "初めまして！ LiftLogはあなたのトレーニングを全力でサポートします。"
    elsif (days % 365).zero?
      years = days / 365
      "おめでとうございます！ 総トレーニング日数が#{days}日（#{years}年）を突破しました🔥 これからもLiftLogが伴走し続けます。"
    else
      "おめでとうございます！ 総トレーニング日数が#{days}日を突破しました🔥"
    end
  end

  def calculate_and_apply_best_for_workout(workout, previous_best_weight:, previous_best_distance:)
    exercise = workout.exercise
    user = workout.user

    all_sets = WorkoutSet.joins(workout: :exercise)
      .where(workouts: { user_id: user.id },
             exercises: { id: exercise.id })

    if exercise.category.name == "有酸素"
      max_distance = all_sets.maximum(:distance) || 0

      if max_distance > previous_best_distance
        exercise.update!(best_distance: max_distance)
        return [max_distance - previous_best_distance, "distance"]
      end
    else
      max_weight = all_sets.maximum(:weight) || 0

      if max_weight > previous_best_weight
        exercise.update!(best_weight: max_weight)
        return [max_weight - previous_best_weight, "weight"]
      end
    end

    [nil, nil]
  end
end
