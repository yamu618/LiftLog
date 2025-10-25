# == Schema Information
#
# Table name: exercises
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  user_id     :bigint
#
# Indexes
#
#  index_exercises_on_category_id  (category_id)
#  index_exercises_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :exercise do
    name { "MyString" }
    category { nil }
  end
end
