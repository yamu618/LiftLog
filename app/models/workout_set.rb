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

  private

  def update_workout_total_weight
    workout.update(total_weight: workout.workout_sets.sum { |s| s.weight * s.reps })
  end
end
