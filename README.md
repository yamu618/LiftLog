<p align="center">
  <img src="app/assets/images/liftlog_ogp.png" width="800">
</p>

# LiftLog

**「記録の手間を最小限にし、継続できる」** をコンセプトにした筋トレ管理アプリです。  
日々のトレーニングを素早く記録し、総重量推移や自己ベストを可視化できます。

実際に自分自身が日常的に使用しながら、  
**ユーザー視点でのUX改善・機能追加を継続して行っています。**

---

## 🌐 本番環境
https://liftlog-app.com

---

## 📘 Qiita 記事
設計・実装・機能の詳細や技術選定の背景、開発中に意識したポイントについて、  
以下の記事にまとめています。

本READMEでは書ききれない内容も含めて整理していますので、  
ご興味がありましたらぜひご覧ください。

👉 https://qiita.com/yamu618/items/fb6239045855150a6c7c

---

## 🎯 開発目的・背景

ポートフォリオ制作にあたり、  
**「自分が継続して使い続けられるアプリを作る」** ことを重視しました。

筋トレを継続する中で感じていた課題は以下の通りです。

- 記録入力が面倒で継続しづらい
- 過去の成長が直感的に分かりにくい

これらを解決するために、

- ワンタップで直近の記録をコピーできる機能
- 非同期通信によるストレスの少ない操作感
- 成長を可視化するレポート機能

などを機能に含めて設計・実装しました。

---

## 🛠 技術スタック

### バックエンド
- Ruby
- Ruby on Rails

### フロントエンド
- Hotwire（Turbo / Stimulus）
- Bootstrap 5

### インフラ・開発環境
- Render
- PostgreSQL（Neon）
- Docker
- GitHub Actions（CI）

---

## 🚀 主な機能

### カレンダー表示（Turbo Frameによる非同期切替）
![calendar](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4009473/52d117c8-88be-4f7a-904c-40606589e399.gif)

### ワークアウト・セット管理
![workout](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4009473/f92f83ae-733c-49f9-87ae-c02e0d513d0e.gif)

### 種目管理
![exercise](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4009473/5ec6d1dd-a29c-4b17-acc8-dab5ddd3f84d.gif)

### レポート機能（総重量推移・自己ベスト）
![report](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4009473/61374a8e-d409-4702-85f3-7052691af1e3.gif)

---

## 🧠 工夫したポイント

### ユーザー課題ベースの機能設計
「記録が面倒」「前回の内容を忘れる」「過去の成長が分かりにくい」という課題に対し、  
直近記録コピー機能や、複数のレポート機能を実装しました。

### UXを意識した非同期処理
Turbo Frame / Turbo Stream を活用し、  
ページリロードを極力減らすことで操作ストレスを軽減しました。

### テストとCIによる品質担保
RSpecとGitHub Actionsを導入し、  
機能追加・修正時の品質を保つ開発フローを意識しています。

---

## 設計、デザイン
**ER図**
![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4009473/5ded30f2-294b-4714-abe5-60478cd8cfe9.png)
**デザイン**
デザインのコンセプトを明確にするために、Figmaを活用してデザインのイメージを作成しました。
![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/4009473/86c140f4-1495-4ff7-8b2f-a582198bf186.png)

---

## 🔮 今後の展望
- モバイルアプリ（Android / Kotlin）対応
- レポート機能の拡充（1RM・体重推移など）
- CDを含めたデプロイ自動化

---

## 最後に
ご覧いただきありがとうございます。  
至らない点も多いですが、フィードバックをもとに改善を続けていきたいと考えています。
