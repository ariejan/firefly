source 'https://rubygems.org'

gem 'bundler'
gem 'rake'
gem 'hanami',       '0.7.2'
gem 'hanami-model', '~> 0.5'

gem 'haml'
gem 'sass'

gem 'sqlite3'
gem 'redis'

gem 'rqrcode'
gem 'sidekiq'

# Required for Sidekiq web dashboard
gem 'sinatra', require: false

group :development do
  gem 'byebug'
end

group :test do
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'capybara'
  gem 'launchy'
  gem 'mocha'

  gem 'guard'
  gem 'guard-minitest'
  gem 'coveralls', require: false
end

group :production do
  # gem 'puma'
end
