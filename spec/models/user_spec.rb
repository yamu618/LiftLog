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
require "rails_helper"
require "ostruct"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "バリデーションエラーがなければ有効" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "usernameがなければ無効" do
      user = build(:user, username: nil)
      expect(user).not_to be_valid
    end

    it "emailがなければ無効" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "passwordがなければ無効" do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it "emailが重複していれば無効" do
      create(:user, email: "unique@example.com")
      dup = build(:user, email: "unique@example.com")

      expect(dup).not_to be_valid
    end

    it "usernameが20文字より長いと無効" do
      user = build(:user, username: "a" * 21)
      expect(user).not_to be_valid
    end

    context "SNSユーザーの場合" do
      it "providerとuidの組み合わせがユニークでなければ無効" do
        create(:user, provider: "google", uid: "abc123")
        dup = build(:user, provider: "google", uid: "abc123")

        expect(dup).not_to be_valid
      end
    end
  end

  describe "コールバック" do
    it "ユーザー作成後にデフォルト種目をコピーする" do
      create(:exercise, name: "ベンチプレス", user: nil)

      user = create(:user)

      expect(user.exercises.pluck(:name)).to include("ベンチプレス")
    end
  end

  describe ".from_omniauth メソッド" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "google",
        uid: "uid123",
        info: OpenStruct.new(
          email: "unique@example.com",
          name: "snsユーザー名が20文字以上のテストユーザー"
        )
      )
    end

    it "既存ユーザーがいなければ新規作成される" do
      expect do
        User.from_omniauth(auth)
      end.to change(User, :count).by(1)
    end

    it "既存ユーザーがいればそれを返す" do
      existing = create(:user, provider: "google", uid: "uid123")

      user = User.from_omniauth(auth)
      expect(user).to eq(existing)
    end

    it "usernameは20文字に切り捨てられる" do
      user = User.from_omniauth(auth)
      expect(user.username.length).to eq(20)
    end
  end
end
