<p align="center">
  <img src="app/assets/images/liftlog_ogp.png" width="800">
</p>

# 💪 LiftLog - シンプルで継続しやすい筋トレ管理アプリ

**LiftLog** は、日々のトレーニングを素早く記録し、総重量・自己ベストの自動記録やグラフ可視化で成長を実感できる筋トレ記録アプリです。  
「記録の手間を最小限にし、継続しやすい設計」にこだわって開発しました。

---

## 🚀 本番環境
🔗 https://liftlog-app.com

---

## ✨ 主な特徴

### 📝 記録がシンプル
- 重量・回数を入力するだけで総重量・自己ベストを自動記録
- 前回セット（重量・回数）のコピー
- ワークアウト・セットを直感的に登録可能

### 📊 成長を“見える化”
- 総重量の月次推移グラフ  
- 自己ベストやトレーニング日数のレポート
- カレンダーで週、月ごとのトレーニング頻度を可視化

### 💡 習慣化を支援
- スマホでも見やすいレスポンシブUI  
- 入力の手間を限界まで削減  
- 継続しやすい軽量な操作感

---

## 🎉 本リリース機能

| カテゴリ | 内容 |
|----------|------|
| ユーザー管理 | Devise によるログイン・登録、SNS ログイン（Google / Apple） |
| ワークアウト管理 | 日付ごとに種目・セット（重量・回数・距離）の登録・編集・削除 |
| 自動計算機能 | セットから総重量・自己ベストなど を自動計算 |
| カテゴリー管理 | 胸・肩・腕・背中・脚・腹・有酸素など部位ごとの分類 |
| 種目管理 | カテゴリー別に自由に追加・編集・削除 |
| 前回セット記録のコピー機能 | 直近のセット内容をコピーし、記録の手間を最小化 |
| カレンダー機能 | SimpleCalendar でトレーニング日を可視化 |
| グラフ機能 | Chartkick + Groupdate で総重量推移を表示 |
| ポップアップメッセージ | トレーニング日数が一定日に到達、自己ベストを更新した際にポップアップメッセージを表示|
| オートコンプリート機能 | 種目追加フォームにオートコンプリート機能を搭載 |
| 管理ページ | rails_admin でユーザーや問い合わせの管理 |
| UI 最適化 | Hotwire（Turbo / Stimulus）による高速 UI |
| CI/CD | GitHub Actions + Render |
| 問い合わせ・パスワードリセット | ユーザー向け基本機能 |
| OGP・ファビコン | SNS 共有時の見た目を最適化 |

---

## 👥 ターゲットユーザー

| ユーザー層 | 特徴 |
|------------|------|
| 初心者〜中級者トレーニー | 記録を手軽に行い、継続のためにモチベーションを保ちたい |
| 忙しい社会人・学生 | すきま時間でサッと記録したい |

---

## 🛠 使用技術

### Backend
- Ruby 3.2.3
- Ruby on Rails 7.2.2
- PostgreSQL

### Frontend
- Hotwire (Turbo / Stimulus)  
- Bootstrap 5

### Infrastructure
- Render  
- GitHub Actions（CI/CD）

### その他主なGem
- Devise  
- Chartkick  
- Groupdate  
- SimpleCalendar  
- cancancan
- rails_admin
- dotenv-rails
- Rubocop  
- RSpec / FactoryBot / Faker

---

## 📐 ER 図
[dbdiagram.ioで確認する](https://dbdiagram.io/d/68f257572e68d21b4100cb5b)

---

## 🎨 画面設計（Figma）
[Figmaデザインを見る](https://www.figma.com/design/dAeNNy30ueoNbF9wYoFmGe/LiftLog?node-id=0-1)

---

## ✅ まとめ

**LiftLog** は、  
**“シンプル操作と継続のしやすさ”** を最優先に設計された筋トレ管理アプリです。

筋トレは、積み上げが力になる。  
**LiftLog は、その積み重ねを後押しするアプリです 💪**
