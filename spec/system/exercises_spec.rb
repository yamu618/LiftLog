require "rails_helper"

RSpec.describe "種目管理（Turbo対応）", type: :system, js: true do
  let(:user) { create(:user) }
  let!(:category) { create(:category) }

  before do
    login_as(user)
  end

  describe "種目の追加" do
    it "フォームに名前を入れて追加できる" do
      visit exercises_path(category_id: category.id)

      fill_in "exercise_name", with: "ベンチプレス"
      click_button "追加"

      expect(page).to have_content("ベンチプレス")
    end
  end

  describe "種目の編集（Turbo Frame）" do
    let!(:exercise) { Exercise.create!(name: "ベンチプレス", user: user, category: category) }

    it "編集 → 更新できる" do
      visit exercises_path(category_id: category.id)

      within "turbo-frame##{dom_id(exercise)}" do
        click_link "編集"
      end

      within "turbo-frame##{dom_id(exercise)}" do
        fill_in "exercise_name", with: "インクラインベンチ"
        click_button "更新"
      end

      expect(page).to have_content("インクラインベンチ")
    end

    it "空では更新できない" do
      visit exercises_path(category_id: category.id)

      within "turbo-frame##{dom_id(exercise)}" do
        click_link "編集"
      end

      within "turbo-frame##{dom_id(exercise)}" do
        fill_in "exercise_name", with: ""
        click_button "更新"
      end

      expect(page).to have_content("種目名を入力してください")
    end

    it "重複した名前に更新できない" do
      Exercise.create!(name: "ダンベルフライ", user: user, category: category)

      visit exercises_path(category_id: category.id)

      within "turbo-frame##{dom_id(exercise)}" do
        click_link "編集"
      end

      within "turbo-frame##{dom_id(exercise)}" do
        fill_in "exercise_name", with: "ダンベルフライ"
        click_button "更新"
      end

      expect(page).to have_content("その種目は既に存在しています")
    end
  end

  describe "種目の削除" do
    let!(:exercise) { Exercise.create!(name: "プレス", user: user, category: category) }

    it "削除できる（Turbo confirm）" do
      visit exercises_path(category_id: category.id)

      accept_confirm do
        within "turbo-frame##{dom_id(exercise)}" do
          click_button "削除"
        end
      end

      expect(page).not_to have_content("プレス")
    end
  end
end
