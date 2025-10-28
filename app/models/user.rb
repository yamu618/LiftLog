# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :workouts, dependent: :destroy
  has_many :exercises, dependent: :destroy

  validates :username, presence: true,
                       length: { maximum: 20 }

  after_create :copy_default_exercises

  def copy_default_exercises
    Exercise.where(user_id: nil).find_each do |template|
      exercises.create!(
        name: template.name,
        category_id: template.category_id
      )
    end
  end
end
