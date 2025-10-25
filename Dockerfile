# ベースイメージ
FROM ruby:3.2.3-slim AS base

# 作業ディレクトリ
WORKDIR /rails

# 必要パッケージ
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      libpq-dev \
      postgresql-client \
      curl \
      git \
      libvips && \
    rm -rf /var/lib/apt/lists/*

# Node.js 18 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Yarn
RUN npm install -g yarn

# 環境変数
ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=1 \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test"

# Gemfile インストール
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Node依存関係インストール
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --production

# アプリ全体をコピー
COPY . .

# assetsのプリコンパイル
RUN --mount=type=secret,id=rails_master_key \
    SECRET_KEY_BASE=$(openssl rand -hex 64) bundle exec rails assets:precompile

# bootsnap 最適化
RUN bundle exec bootsnap precompile app/ lib/

# 非rootユーザー作成
RUN groupadd --system --gid 1000 rails && \
    useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash rails && \
    chown -R 1000:1000 /rails
USER 1000:1000

# Renderが使用するポート
EXPOSE 3000

# Puma起動
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
