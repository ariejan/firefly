require File.expand_path('../../lib/firefly', __FILE__)

require 'sinatra'
require 'rack/test'
require 'database_cleaner'

require 'coveralls'
Coveralls.wear!

set :environment,   :test
set :run,           false
set :raise_errors,  true
set :logging,       nil

ActiveRecord::Base.logger = nil

module RSpecMixin
  include Rack::Test::Methods
  def app
    Firefly::Server.new(File.join(Firefly.root, 'spec/firefly.yml'))
  end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    Firefly::CodeFactory.create(count: 0)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Firefly::CodeFactory.create(count: 0)
  end

  # Loads the urls.yml fixtures.
  def load_fixtures
    Firefly::Url.destroy
    urls = YAML::load(File.open('spec/fixtures/urls.yml'))
    urls.each { |key, url| Firefly::Url.create(url) }
  end

  # Load a spec file and return its contents
  def spec_file(filename)
    File.open('spec/files/'+filename) { |f| f.read }
  end
end
