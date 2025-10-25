set -ex

set -ex

bundle install --jobs 4 --retry 3
yarn install --frozen-lockfile
bundle exec rails db:migrate
bundle exec rails db:seed
