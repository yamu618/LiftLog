require "rails_helper"

RSpec.describe "ワークアウトセット管理", type: :system do
  let(:user) { create(:user) }
  let!(:category) { create(:category) }
  let!(:exercise) { create(:exercise, category: category, user: user) }
  let!(:workout) { create(:workout, exercise: exercise, user: user, performed_on: Time.zone.today) }

  before do
    login_as(user)
  end

  describe "セット追加" do
    it "正しい情報でセットを追加できる" do
      visit new_set_workout_path(workout)

      fill_in "重量(kg)", with: 50
      fill_in "回数(回)", with: 10
      click_button "登録"

      expect(page).to have_content("セットを追加しました")
      expect(WorkoutSet.last.reload.weight).to eq(50)
      expect(WorkoutSet.last.reload.reps).to eq(10)
    end

    it "重量と回数が0未満の場合エラーが発生する" do
      visit new_set_workout_path(workout)

      fill_in "重量(kg)", with: -1
      fill_in "回数(回)", with: -1
      click_button "登録"

      expect(page).to have_content("重量は0.0以上の値にしてください")
      expect(page).to have_content("回数は0以上の値にしてください")
      expect(current_path).to eq(new_set_workout_path(workout))
    end

    it "重量と回数を入力しない場合エラーが発生する" do
      visit new_set_workout_path(workout)

      fill_in "重量(kg)", with: ""
      fill_in "回数(回)", with: ""
      click_button "登録"

      expect(page).to have_content("重量を入力してください")
      expect(page).to have_content("回数を入力してください")
      expect(current_path).to eq(new_set_workout_path(workout))
    end
  end

  describe "セット一覧" do
    let!(:set_a) { create(:workout_set, workout: workout, weight: 40, reps: 0) } # rubocop:disable RSpec/LetSetup

    it "セットが一覧表示される" do
      visit workout_path(workout)

      expect(page).to have_content("40")
      expect(page).to have_content("8")
      expect(page).to have_content("50")
      expect(page).to have_content("10")
    end
  end

  describe "セット編集" do
    let!(:set) { create(:workout_set, workout: workout, weight: 40, reps: 8) }

    it "セットの重量と回数を編集できる" do
      visit edit_workout_set_path(set)

      fill_in "重量(kg)", with: 45
      fill_in "回数(回)", with: 9
      click_button "更新"

      expect(page).to have_content("セットを更新しました")
      expect(WorkoutSet.last.reload.weight).to eq(45)
      expect(WorkoutSet.last.reload.reps).to eq(9)
    end

    it "重量と回数が0未満の場合エラーが発生する" do
      visit edit_workout_set_path(set)

      fill_in "重量(kg)", with: -1
      fill_in "回数(回)", with: -1
      click_button "更新"

      expect(page).to have_content("重量は0.0以上の値にしてください")
      expect(page).to have_content("回数は0以上の値にしてください")
      expect(current_path).to eq(edit_workout_set_path(set))
    end

    it "重量と回数を入力しない場合エラーが発生する" do
      visit edit_workout_set_path(set)

      fill_in "重量(kg)", with: ""
      fill_in "回数(回)", with: ""
      click_button "更新"

      expect(page).to have_content("重量を入力してください")
      expect(page).to have_content("回数を入力してください")
      expect(current_path).to eq(edit_workout_set_path(set))
    end
  end

  describe "セット削除" do
    let!(:set) { create(:workout_set, workout: workout, weight: 50, reps: 10) }

    it "セットを削除できる" do
      visit workout_path(workout)

      accept_confirm do
        click_link "削除"
      end

      expect(page).to have_content("セットを削除しました")
      expect(WorkoutSet.where(id: set.id)).not_to exist
    end
  end
end
