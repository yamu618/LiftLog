<p align="center">
  <img src="app/assets/images/liftlog_ogp.png" width="800">
</p>

# LiftLog

LiftLogは、日々のトレーニングを素早く記録し、総重量推移のグラフや自己ベストなどのレポート機能を通して成長を可視化できる筋トレ管理アプリです。

「記録の手間を最小限にし、継続しやすいこと」を重視し、シンプルな操作やAjax通信などを中心としたUI/UX設計を行いました。

主にスマートフォンでの利用を前提に開発しています。

---

## 🌐 本番環境
https://liftlog-app.com

---

## 📘 Qiita 記事
設計・実装・機能の詳細や技術選定の背景、開発中に意識したポイントについて、  
以下の記事にまとめています。

本READMEでは書ききれない内容も含めて整理していますので、  
ご興味がありましたらぜひご覧ください。

[【ポートフォリオ】筋トレ管理アプリ「LiftLog」を開発しました（Ruby x Rails x Hotwire）](https://qiita.com/yamu618/items/fb6239045855150a6c7c)

---

## 🎯 開発目的・背景

ポートフォリオを制作するにあたり、自分自身が継続して使い続けられ、最も利用頻度の高いユーザーになれるアプリを作りたいと考えました。

私は週に3〜5日ジムで筋トレを行っており、筋トレ管理アプリであれば、転職活動後も継続して開発・改善に取り組むモチベーションを維持できると考えました。また、自分自身が日常的に使うユーザーになることで、実体験に基づいたユーザー目線での機能改善やUI/UX設計ができる点にも魅力を感じました。

以上の理由から、ポートフォリオとして技術力をアピールできることに加え、今後も運用・改善を続けていける題材として、筋トレ管理アプリを選択しました。

アプリケーションとしては自分の考える機能が整ったためリリースしましたが、今後様々な機能を追加していきたいと思っております。

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
最後までご覧いただき、ありがとうございます。

本アプリケーションは、初学者なりに試行錯誤を重ねながら設計・実装を行いました。

至らない点や改善の余地は多くあると考えておりますが、ご意見やご指摘は今後の学習・開発に積極的に活かしていきたいと考えていますので、ぜひ率直なフィードバックをいただけますと幸いです。
