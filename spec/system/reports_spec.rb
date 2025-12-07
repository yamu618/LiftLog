require "rails_helper"

RSpec.describe "Reports", type: :system do
  let(:user) { create(:user) }
  let!(:category) { create(:category, name: "筋トレ") }
  let!(:exercise) { create(:exercise, user: user, category: category, name: "ベンチプレス") }
  let!(:workout) { create(:workout, user: user, exercise: exercise, performed_on: Date.today) }
  let!(:workout_set) { create(:workout_set, workout: workout, weight: 50, reps: 10) }

  before do
    login_as(user)
  end

  it "アクセスでき、ページタイトルと基本情報が表示される" do
    visit reports_path

    expect(page).to have_content("トレーニングレポート")
    expect(page).to have_content("総日数")
    expect(page).to have_content("#{user.workouts.count} 日")
    expect(page).to have_link(exercise.name)
  end

  it "種目を選択すると自己ベストが表示される" do
    visit reports_path(category_id: category.id)

    within "#category_tabs_and_exercises_personal_best" do
      click_on exercise.name
    end

    expect(page).to have_content("自己ベスト")
    expect(page).to have_content(exercise.name)
  end
end
