
# syntax = docker/dockerfile:1

# Rails用Rubyイメージ（RenderはDebianベース推奨）
ARG RUBY_VERSION=3.2.3
FROM ruby:$RUBY_VERSION-slim AS base

# Railsアプリの作業ディレクトリ
WORKDIR /rails

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      build-essential \
      libpq-dev \
      postgresql-client \
      libvips \
      git && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Node.js 18 LTSをインストール（最新安定版）
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Yarnをインストール
RUN npm install -g yarn

# Rails環境設定
ENV RAILS_ENV="production" \
    RAILS_LOG_TO_STDOUT="1" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Gemfileをコピーしてbundle install
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3 && \
    rm -rf ~/.bundle "${BUNDLE_PATH}/ruby/*/cache" "${BUNDLE_PATH}/ruby/*/bundler/gems/*/.git"

# package.jsonがある場合のNode.js依存関係インストール
COPY package*.json yarn.lock* ./
RUN if [ -f "package.json" ]; then yarn install --frozen-lockfile --production; fi

# アプリケーションをコピー
COPY . .

# assetsのプリコンパイル
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# bootsnap最適化
RUN bundle exec bootsnap precompile app/ lib/

# 非rootユーザー作成とファイル権限設定
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R 1000:1000 /rails
USER 1000:1000

# ヘルスチェック用エンドポイント
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Renderが使用するポートを指定
EXPOSE 3000

# puma起動
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
