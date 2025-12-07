# == Schema Information
#
# Table name: exercises
#
#  id            :bigint           not null, primary key
#  best_distance :float
#  best_weight   :float
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :bigint           not null
#  user_id       :bigint
#
# Indexes
#
#  index_exercises_on_category_id                       (category_id)
#  index_exercises_on_name_and_category_id_and_user_id  (name,category_id,user_id) UNIQUE
#  index_exercises_on_user_id                           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Exercise, type: :model do
  describe "バリデーション" do
    let(:category) { create(:category) }

    it "nameとcategoryがあれば有効" do
      exercise = build(:exercise, category: category)
      expect(exercise).to be_valid
    end

    it "nameがなければ無効" do
      exercise = build(:exercise, name: nil, category: category)
      expect(exercise).not_to be_valid
    end

    it "同じcategoryとuserでnameが重複すると無効" do
      user = create(:user)
      create(:exercise, name: "ベンチプレス", category: category, user: user)
      dup = build(:exercise, name: "ベンチプレス", category: category, user: user)

      expect(dup).not_to be_valid
    end
  end

  describe "アソシエーション" do
    it "categoryに属すること" do
      assoc = described_class.reflect_on_association(:category)
      expect(assoc.macro).to eq :belongs_to
    end

    it "userに属すること（任意）" do
      assoc = described_class.reflect_on_association(:user)
      expect(assoc.macro).to eq :belongs_to
      expect(assoc.options[:optional]).to be true
    end

    it "workoutsを持つこと" do
      assoc = described_class.reflect_on_association(:workouts)
      expect(assoc.macro).to eq :has_many
    end
  end
end
