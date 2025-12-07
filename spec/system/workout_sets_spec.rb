require "rails_helper"

RSpec.describe "ワークアウトセット管理（Turbo Frame）", type: :system, js: true do
  let(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:exercise) { create(:exercise, category: category, user: user) }
  let!(:workout) { create(:workout, exercise: exercise, user: user, performed_on: Time.zone.today) }

  before do
    login_as(user)
  end

  describe "セット追加" do
    it "正しい情報でセットを追加できる" do
      visit workout_path(workout)

      click_link "セット追加"

      within("form") do
        fill_in "重量", with: 50
        fill_in "回数", with: 10
        click_button "登録"
      end

      expect(page).to have_content("セットを追加しました")
      expect(WorkoutSet.last.reload.weight).to eq(50)
      expect(WorkoutSet.last.reload.reps).to eq(10)
    end
  end

  describe "セット編集" do
    let!(:set) { create(:workout_set, workout: workout, weight: 40, reps: 8) }

    it "セットの重量と回数を編集できる" do
      visit workout_path(workout)

      within("#workout_set_#{set.id}") do
        click_link "編集"
        fill_in "重量", with: 45
        fill_in "回数", with: 9
        click_button "更新"
      end

      expect(page).to have_content("45.0kg")
      expect(page).to have_content("9回")
    end

    it "入力が不正な場合エラーが表示される" do
      visit workout_path(workout)

      within("#workout_set_#{set.id}") do
        click_link "編集"
        fill_in "重量", with: ""
        fill_in "回数", with: ""
        click_button "更新"
      end

      expect(page).to have_content("重量・回数は0以上で入力してください")
    end
  end

  describe "セット削除" do
    let!(:set) { create(:workout_set, workout: workout, weight: 50, reps: 10) }

    it "セットを削除できる" do
      visit workout_path(workout)

      within("#workout_set_#{set.id}") do
        click_button "削除"
      end

      expect(page).to have_content("セットを削除しました")
      expect(WorkoutSet.where(id: set.id)).not_to exist
    end
  end
end
