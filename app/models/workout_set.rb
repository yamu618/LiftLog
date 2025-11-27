# == Schema Information
#
# Table name: workout_sets
#
#  id         :bigint           not null, primary key
#  distance   :float            default(0.0), not null
#  duration   :integer          default(0), not null
#  reps       :integer          default(0), not null
#  weight     :float            default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  workout_id :bigint           not null
#
# Indexes
#
#  index_workout_sets_on_workout_id  (workout_id)
#
# Foreign Keys
#
#  fk_rails_...  (workout_id => workouts.id)
#
class WorkoutSet < ApplicationRecord
  belongs_to :workout

  with_options if: -> { workout.exercise.category.name != "有酸素" } do
    validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
    validates :reps, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  end

  with_options if: -> { workout.exercise.category.name == "有酸素" } do
    validates :duration, presence: true, numericality: { greater_than: 0, only_integer: true }
    validates :distance, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  end

  after_save :update_workout_total_weight
  after_destroy :update_workout_total_weight
  after_save :update_exercise_best
  after_destroy :update_exercise_best

  private

  def update_workout_total_weight
    workout.update(total_weight: workout.workout_sets.sum { |s| s.weight * s.reps })
  end

  def update_exercise_best
    exercise = workout.exercise

    all_sets = WorkoutSet.joins(workout: :exercise)
                         .where(workouts: { user_id: workout.user_id},
                                exercises: { id: exercise.id })

    if exercise.category.name == "有酸素"
      max_distance = all_sets.maximum(:distance)
      exercise.update(best_distance: max_distance || 0)
    else
      max_weight = all_sets.maximum(:weight)
      exercise.update(best_weight: max_weight || 0)
    end
  end
end
