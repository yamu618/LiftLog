# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_provider_and_uid      (provider,uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :workouts, dependent: :destroy
  has_many :exercises, dependent: :destroy
  has_many :workout_sets, through: :workouts

  validates :username, presence: true,
                       length: { maximum: 20 }
  validates :uid, uniqueness: { scope: :provider}

  after_create :copy_default_exercises

  def copy_default_exercises
    Exercise.where(user_id: nil).find_each do |template|
      exercises.create!(
        name: template.name,
        category_id: template.category_id
      )
    end
  end

  def self.from_omniauth(auth)
    #SNSから取得した名前の補正
    raw_name = auth.info.name.to_s.strip
    username = raw_name[0...20] 
    username = "user_#{SecureRandom.hex(4)}" if username.blank? || username.gsub(/\W/, '').blank?

    # providerとuidでユーザーを検索 or 作成
    User.find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.username = username
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
