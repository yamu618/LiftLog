# == Schema Information
#
# Table name: workouts
#
#  id             :bigint           not null, primary key
#  calculated_1rm :float
#  performed_on   :date             not null
#  total_weight   :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  exercise_id    :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_workouts_on_exercise_id               (exercise_id)
#  index_workouts_on_performed_on              (performed_on)
#  index_workouts_on_user_id                   (user_id)
#  index_workouts_on_user_id_and_performed_on  (user_id,performed_on)
#
# Foreign Keys
#
#  fk_rails_...  (exercise_id => exercises.id)
#  fk_rails_...  (user_id => users.id)
#
class Workout < ApplicationRecord
  belongs_to :user
  belongs_to :exercise
  has_many :workout_sets, dependent: :destroy

  # TODO: 統計機能開発時に0の扱いを見直す
  validates :performed_on, presence: true
end
