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
require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'バリデーション' do
    it 'message が必須' do
      contact = build(:contact, message: nil)
      expect(contact).not_to be_valid
    end

    it 'message は1000文字まで' do
      contact = build(:contact, message: 'a' * 1001)
      expect(contact).not_to be_valid
    end

    it 'email があれば正しい形式である必要がある' do
      contact = build(:contact, email: 'invalid')
      expect(contact).not_to be_valid
    end

    it 'name は50文字まで' do
      contact = build(:contact, name: 'a' * 51)
      expect(contact).not_to be_valid
    end
  end
end
