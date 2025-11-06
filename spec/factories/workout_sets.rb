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
FactoryBot.define do
  factory :workout_set do
    association :workout
    weight { 60 }
    reps { 10 }
  end
end
