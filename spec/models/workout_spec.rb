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
require "rails_helper"

RSpec.describe Workout, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
