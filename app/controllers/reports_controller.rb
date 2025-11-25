class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_days = current_user.workouts.select(:performed_on).distinct.count
    @this_week_days, @last_week_days = week_days_counts
    @week_days_diff = @this_week_days - @last_week_days
    @this_month_days, @last_month_days = month_days_counts
    @month_days_diff = @this_month_days - @last_month_days

#    @this_week_weight, @last_week_weight = week_weight_sums
#    @week_weight_diff = @this_week_weight - @last_week_weight
#    @this_month_weight, @last_month_weight = month_weight_sums
#    @month_weight_diff = @this_month_weight - @last_month_weight

    @categories = Category.all.order(:id)
    @selected_category = params[:category_id].present? ? Category.find(params[:category_id]) : @categories.first
    
    if @selected_category.name == "有酸素"
      @cardio_exercises = current_user.exercises.where(category: @selected_category).order(:name)
      @selected_exercise = params[:exercise_id].present? ? current_user.exercises.find_by(id: params[:exercise_id]) : nil

      if @selected_exercise
        data = @selected_exercise.workouts.joins(:workout_sets)
                          .group_by_month(:performed_on, last: 12, time_zone: "Tokyo")
                          .sum("workout_sets.distance")
        @chart_data_rounded = data.transform_values { |v| v.round(2) }
      else
        @chart_data_rounded = {}
      end
    else
      @exercises = current_user.exercises.where(category: @selected_category).order(:name)
      @selected_exercise = params[:exercise_id].present? ? current_user.exercises.find_by(id: params[:exercise_id]) : nil

      if @selected_exercise
        data = @selected_exercise.workouts
                .group_by_month(:performed_on, last: 12, time_zone: "Tokyo")
                .sum(:total_weight)
        @chart_data_rounded = data.transform_values { |v| v.round(2) }
      else
        @chart_data_rounded = {}
      end
    end
  end

  private

  def week_days_counts
    this_week = current_user.workouts
      .where(performed_on: Time.zone.today.beginning_of_week..Time.zone.today.end_of_week)
      .select(:performed_on).distinct.count

    last_week = current_user.workouts
      .where(performed_on: 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
      .select(:performed_on).distinct.count

    [this_week, last_week]
  end

  def month_days_counts
    this_month = current_user.workouts
      .where(performed_on: Time.zone.today.beginning_of_month..Time.zone.today.end_of_month)
      .select(:performed_on).distinct.count

    last_month = current_user.workouts
      .where(performed_on: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
      .select(:performed_on).distinct.count

    [this_month, last_month]
  end

#  def week_weight_sums
#    this_week = current_user.workouts
#      .joins(:workout_sets)
#      .where(performed_on: Time.zone.today.beginning_of_week..Time.zone.today.end_of_week)
#      .sum("workout_sets.weight * workout_sets.reps")

#    last_week = current_user.workouts
#      .joins(:workout_sets)
#      .where(performed_on: 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
#      .sum("workout_sets.weight * workout_sets.reps")

#    [this_week, last_week]
#  end

#  def month_weight_sums
#    this_month = current_user.workouts
#      .joins(:workout_sets)
#      .where(performed_on: Time.zone.today.beginning_of_month..Time.zone.today.end_of_month)
#      .sum("workout_sets.weight * workout_sets.reps")

#    last_month = current_user.workouts
#      .joins(:workout_sets)
#      .where(performed_on: 1.month.ago.beginning_of_month..1.month.ago.end_of_month)
#      .sum("workout_sets.weight * workout_sets.reps")

#    [this_month, last_month]
#  end
end
