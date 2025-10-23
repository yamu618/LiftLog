# == Schema Information
#
# Table name: exercises
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#
# Indexes
#
#  index_exercises_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
class Exercise < ApplicationRecord
  has_many :workouts, dependent: :destroy
  belongs_to :category

  validates :name, presence: true, uniqueness: { scope: [:category_id, :user_id] }
end
