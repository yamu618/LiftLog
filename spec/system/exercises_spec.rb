require "rails_helper"

RSpec.describe "Exercises", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before do
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

  describe "種目一覧", :js do
    before do
      Rails.application.load_seed if Rails.env.test?
    end

    it "カテゴリーを選択するとそのカテゴリーの種目だけが表示される" do
      expect(page).to have_content("ログアウト")

      visit exercises_path(category_id: Category.first)

      expect(page).to have_content("ベンチプレス")
      expect(page).not_to have_content("デッドリフト")

      click_link "背中"
      expect(page).to have_content("デッドリフト")
      expect(page).not_to have_content("ベンチプレス")

      click_link "脚"
      expect(page).to have_content("スクワット")
      expect(page).not_to have_content("ベンチプレス")

      click_link "肩"
      expect(page).to have_content("ショルダープレス")
      expect(page).not_to have_content("ベンチプレス")

      click_link "腕"
      expect(page).to have_content("バーベルカール")
      expect(page).not_to have_content("ベンチプレス")

      click_link "有酸素"
      expect(page).to have_content("ウォーキング")
      expect(page).not_to have_content("ベンチプレス")
    end
  end

  describe "種目の追加", :js do
    before { Rails.application.load_seed if Rails.env.test? }

    it "正しい情報入力で追加できる" do
      expect(page).to have_content("ログアウト")
      visit exercises_path(category_id: Category.first)
      fill_in "exercise_name", with: "プッシュアップ"
      click_button "追加"

      expect(page).to have_content("種目を追加しました")
      expect(page).to have_content("プッシュアップ")
    end

    it "種目名が空の場合は追加できない" do
      expect(page).to have_content("ログアウト")
      visit exercises_path(category_id: Category.first)
      fill_in "exercise_name", with: ""
      click_button "追加"

      expect(page).to have_content("種目名を入力してください")
    end

    it "種目名が重複している場合は追加できない" do
      expect(page).to have_content("ログアウト")
      visit exercises_path(category_id: Category.first)
      fill_in "exercise_name", with: "ベンチプレス"
      click_button "追加"

      expect(page).to have_content("その種目は既に存在しています")
    end
  end

  describe "種目の編集", :js do
    let!(:category) { Category.create!(name: "テスト用カテゴリー") }
    let!(:exercise) { Exercise.create!(name: "テスト用種目", category: category, user: user) }

    it "正しい情報で名前を編集できる" do
      expect(page).to have_content("ログアウト")
      visit edit_exercise_path(exercise)

      fill_in "exercise_name", with: "編集後の種目"
      click_button "更新"

      expect(page).to have_content("種目を更新しました")
      expect(page).to have_content("編集後の種目")
    end

    it "種目名が空の場合は更新できない" do
      expect(page).to have_content("ログアウト")
      visit edit_exercise_path(exercise)

      fill_in "exercise_name", with: ""
      click_button "更新"

      expect(page).to have_content("種目名を入力してください")
    end

    it "種目名が重複している場合は更新できない" do
      expect(page).to have_content("ログアウト")
      Exercise.create!(name: "重複テスト種目", category: category, user: user)

      visit edit_exercise_path(exercise)

      fill_in "exercise_name", with: "重複テスト種目"
      click_button "更新"

      expect(page).to have_content("その種目は既に存在しています")
    end
  end

  describe "種目の削除", :js do
    before { Rails.application.load_seed if Rails.env.test? }

    it "削除できる" do
      expect(page).to have_content("ログアウト")
      visit exercises_path(category_id: Category.first)

      within(find(".list-group-item", text: /ディップス/)) do
        accept_confirm "本当に削除しますか？" do
          click_button "削除"
        end
      end

      expect(page).to have_content("種目を削除しました")
      expect(page).not_to have_content("ディップス")
    end
  end
end
