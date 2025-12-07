require "rails_helper"

RSpec.describe "ワークアウト管理", :js, type: :system do
  let(:user) { create(:user) }
  let!(:category) { create(:category, name: "カテゴリー1") }
  let!(:exercise) { create(:exercise, user: user, category: category) }

  before do
    login_as(user)
  end

  describe "一覧ページ" do
    let!(:workout) { create(:workout, user: user, exercise: exercise) }

    it "ワークアウトが一覧に表示される" do
      visit workouts_path
      expect(page).to have_content(exercise.name)
      expect(page).to have_content(category.name)
    end
  end

  describe "新規作成" do
    it "正しい情報でワークアウトを作成出来る" do
      visit new_workout_path

      click_link category.name

      find("label", text: exercise.name).click

      click_button "作成"

      expect(page).to have_content("ワークアウトを作成しました")
      expect(Workout.last.exercise.name).to eq(exercise.name)
    end

    it "種目未入力でエラーになる" do
      visit new_workout_path

      click_button "作成"

      expect(page).to have_content("種目を選択してください。")
    end
  end

  describe "詳細ページ" do
    let!(:workout) { create(:workout, user: user, exercise: exercise) }

    it "ワークアウト詳細ページが表示される" do
      visit workout_path(workout)

      expect(page).to have_content("セット管理")
      expect(page).to have_content(exercise.name)
    end
  end

  describe "削除" do
    let!(:workout) { create(:workout, user: user, exercise: exercise) }

    it "ワークアウトを削除できる" do
      visit workouts_path

      within("#workout_#{workout.id}") do
        accept_confirm "削除しますか？" do
          click_link "削除"
        end
      end

      expect(page).to have_content("ワークアウトを削除しました")
      expect(Workout.where(id: workout.id)).not_to exist
    end
  end
end
