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
require 'rails_helper'

RSpec.describe Workout, type: :model do
  describe 'アソシエーション' do
    it 'user に属している' do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'exercise に属している' do
      assoc = described_class.reflect_on_association(:exercise)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'workout_sets を複数持つ' do
      assoc = described_class.reflect_on_association(:workout_sets)
      expect(assoc.macro).to eq :has_many
    end
  end

  describe 'バリデーション' do
    it 'performed_on が必須' do
      workout = build(:workout, performed_on: nil)
      expect(workout).not_to be_valid
    end
  end

  describe 'インスタンスメソッド' do
    it 'total_weight が合計を返す' do
      workout = create(:workout)
      create(:workout_set, workout:, weight: 10, reps: 5)

      expect(workout.total_weight).to eq(50)
    end

    it 'total_distance の合計が返る' do
      workout = create(:workout)
      create(:workout_set, workout:, distance: 300)
      create(:workout_set, workout:, distance: 200)

      expect(workout.total_distance).to eq(500)
    end

    it 'total_duration の合計が返る' do
      workout = create(:workout)
      create(:workout_set, workout:, duration: 60)
      create(:workout_set, workout:, duration: 30)

      expect(workout.total_duration).to eq(90)
    end
  end
end
