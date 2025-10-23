# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  has_many :workouts, dependent: :destroy

  validates :name, presenec: true, uniqueness: true
end
