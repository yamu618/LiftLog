# == Schema Information
#
# Table name: workout_sets
#
#  id         :bigint           not null, primary key
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

  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0.0 }
  validates :reps, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
end
