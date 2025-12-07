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
  describe "アソシエーション" do
    it "workout に属している" do
      assoc = described_class.reflect_on_association(:workout)
      expect(assoc.macro).to eq :belongs_to
    end
  end

  describe "バリデーション" do
    context "筋トレ（有酸素以外）の場合" do
      let(:category) { create(:category, name: "テスト") }
      let(:exercise) { create(:exercise, category:) }
      let(:workout)  { create(:workout, exercise:) }

      it "weight と reps が必須" do
        set = build(:workout_set, workout:, weight: nil, reps: nil)
        expect(set).not_to be_valid
      end
    end

    context "有酸素の場合" do
      let(:category) { Category.find_or_create_by!(name: "有酸素") }
      let(:exercise) { create(:exercise, category:) }
      let(:workout)  { create(:workout, exercise:) }

      it "duration と distance が必須" do
        set = build(:workout_set, workout:, duration: nil, distance: nil)
        expect(set).not_to be_valid
      end
    end
  end
end
