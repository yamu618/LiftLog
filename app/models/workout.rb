# == Schema Information
#
# Table name: workouts
#
#  id             :bigint           not null, primary key
#  calculated_1rm :float
#  performed_on   :date             not null
#  reps           :integer          default(0), not null
#  total_weight   :float
#  weight         :float            default(0.0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  exercise_id    :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_workouts_on_exercise_id  (exercise_id)
#  index_workouts_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (exercise_id => exercises.id)
#  fk_rails_...  (user_id => users.id)
#
class Workout < ApplicationRecord
  belongs_to :user
  belongs_to :exercise

  # TODO: 統計機能開発時に0の扱いを見直す
  validates :weight, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :reps, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :performed_on, presence: true

end
