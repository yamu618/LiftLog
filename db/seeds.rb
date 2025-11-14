puts "シードデータの作成を開始"

if Rails.env.development?
  puts "既存データをクリア"
  Workout.destroy_all
  Exercise.destroy_all
  Category.destroy_all
  User.destroy_all

  puts "開発環境用のテストユーザーを作成"
  user = User.create!(
      username: "admin",
      email: "testadmin@example.com",
      password: "password",
      password_confirmation: "password",
      admin: true
    )
  puts "#{user.username} を作成しました"
end

puts "カテゴリーと種目を作成"

exercise_data = {
  "胸" => ["ベンチプレス", "チェストプレス", "インクラインベンチプレス", "ダンベルプレス", "ダンベルフライ", "ケーブルフライ", "ディップス"],
  "背中" => ["デッドリフト", "ラットプルダウン", "バーベルローイング", "ダンベルローイング", "マシンローイング", "懸垂", "バックエクステンション"],
  "脚" => ["スクワット", "レッグプレス", "レッグエクステンション", "レッグカール"],
  "肩" => ["ショルダープレス", "サイドレイズ", "フロントレイズ"],
  "腕" => ["バーベルカール", "ダンベルカール", "トライセップスエクステンション", "ハンマーカール", "ケーブルプッシュダウン", "ケーブルカール"],
  "腹" => ["クランチ", "レッグレイズ", "ツイストクランチ", "ツイストレッグレイズ"],
  "有酸素" => ["ウォーキング", "ランニング", "エアロバイク", "クロストレーナー"]
}

categories = []
exercises = []

exercise_data.each do |category_name, exercise_names|
  category = Category.find_or_create_by!(name: category_name)
  categories << category

  exercise_names.each do |exercise_name|
    exercise = Exercise.find_or_create_by!(
      name: exercise_name,
      category: category
    )
    exercises << exercise
  end
end

if Rails.env.production?
  admin_email = ENV['ADMIN_EMAIL']
  admin_password = ENV['ADMIN_PASSWORD']

  User.find_or_create_by!(email: admin_email) do |user|
    user.username = 'admin'
    user.password = admin_password
    user.password_confirmation = admin_password
    user.admin = true
  end
end
