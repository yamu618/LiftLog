require 'rails_helper'

RSpec.describe "ユーザー認証", type: :system do
  let(:user) { create(:user) }

  it "ユーザー新規登録ができる" do
    visit new_user_registration_path

    fill_in "ユーザー名", with: "testuser"
    fill_in "メールアドレス", with: "test@example.com"
    fill_in "パスワード", with: "password123"
    fill_in "パスワード（確認）", with: "password123"
    click_button "登録する"

    expect(page).to have_content("アカウント登録が完了しました")
  end

  it "ユーザーがログイン出来る" do
    user = create(:user)
    visit new_user_session_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"

    expect(page).to have_content("ログインしました")
  end

  it "ログアウトできる" do
    user = create(:user)
    visit new_user_session_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    
    visit root_path

    expect(page).to have_button "ログアウト"

    accept_confirm do
      click_button "ログアウト"
    end

    expect(page).to have_content("ログアウトしました")
  end

  it "プロフィール編集できる" do
    login_as(user, scope: :user)
    visit edit_user_registration_path

    fill_in "ユーザー名", with: "updated_name"
    fill_in "現在のパスワード（必須）", with: user.password
    click_button "更新"

    expect(page).to have_content("アカウント情報を変更しました")
    expect(user.reload.username).to eq("updated_name")
  end

  it "アカウント削除できる" do
    login_as(user, scope: :user)
    visit edit_user_registration_path

    accept_confirm do
      click_link "アカウント削除"
    end

    expect(page).to have_content("アカウントを削除しました")
    expect(User.exists?(user.id)).to be_falsey
  end
end
