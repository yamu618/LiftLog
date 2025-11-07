puts "🌱 シードデータの作成を開始します..."

# === 開発環境のみ処理 ===
if Rails.env.development?
  puts "既存データをクリアしています..."
  Workout.destroy_all
  Exercise.destroy_all
  Category.destroy_all
  User.destroy_all

  puts "開発環境用のテストユーザーを作成しています..."
  users = []
  3.times do |i|
    user = User.create!(
      username: "ユーザー#{i + 1}",
      email: "user#{i + 1}@example.com",
      password: "password",
      password_confirmation: "password"
    )
    users << user
    puts "#{user.username} を作成しました"
  end
end

# === カテゴリーと種目作成 ===
puts "カテゴリーと種目を作成しています..."

exercise_data = {
  "胸" => ["ベンチプレス", "チェストプレス", "インクラインベンチプレス", "ダンベルプレス", "ダンベルフライ", "ケーブルフライ", "ディップス"],
  "背中" => ["デッドリフト", "ラットプルダウン", "バーベルローイング", "ダンベルローイング", "マシンローイング", "懸垂", "バックエクステンション"],
  "脚" => ["スクワット", "レッグプレス", "レッグエクステンション", "レッグカール"],
  "肩" => ["ショルダープレス", "サイドレイズ", "フロントレイズ"],
  "腕" => ["バーベルカール", "ダンベルカール", "トライセップスエクステンション", "ハンマーカール", "ケーブルプッシュダウン", "ケーブルカール"],
  "有酸素" => ["ウォーキング", "ランニング", "エアロバイク", "クロストレーナー"]
}

categories = []
exercises = []

exercise_data.each do |category_name, exercise_names|
  category = Category.find_or_create_by!(name: category_name)
  categories << category
  puts "カテゴリー「#{category.name}」を作成しました"

  exercise_names.each do |exercise_name|
    exercise = Exercise.find_or_create_by!(
      name: exercise_name,
      category: category
    )
    exercises << exercise
    puts "  種目「#{exercise.name}」を作成しました"
  end
end

puts "✅ シードデータの作成が完了しました！"
puts "👤 ユーザー: #{User.count}人"
puts "📂 カテゴリー: #{Category.count}個"
puts "🏋️‍♂️ 種目: #{Exercise.count}個"

AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end if Rails.env.development?

AdminUser.find_or_create_by!(email: ENV['ADMIN_EMAIL']) do |admin|
  admin.password = ENV['ADMIN_PASSWORD']
  admin.password_confirmation = ENV['ADMIN_PASSWORD']
end if Rails.env.production?
