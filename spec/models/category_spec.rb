# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#
require "rails_helper"

RSpec.describe Category, type: :model do
  describe "バリデーション" do
    it "nameがあれば有効" do
      category = build(:category)
      expect(category).to be_valid
    end

    it "nameがなければ無効" do
      category = build(:category, name: nil)
      expect(category).not_to be_valid
    end

    it "nameが重複していれば無効" do
      create(:category, name: "テスト")
      dup = build(:category, name: "テスト")
      expect(dup).not_to be_valid
    end
  end

  describe "アソシエーション" do
    it "exercisesを持つことができる" do
      assoc = described_class.reflect_on_association(:exercises)
      expect(assoc.macro).to eq :has_many
    end
  end
end
