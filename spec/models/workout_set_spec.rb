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
require "rails_helper"

RSpec.describe WorkoutSet, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
