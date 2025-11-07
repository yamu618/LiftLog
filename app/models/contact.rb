# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  email      :string
#  message    :text             not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Contact < ApplicationRecord
  validates :message, presence: true, length: { maximum: 1000 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :name, length: { maximum: 50 }, allow_blank: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name email created_at]
  end
end
