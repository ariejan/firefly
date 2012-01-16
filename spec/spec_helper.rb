require File.join(File.dirname(__FILE__), '..', 'lib', 'firefly.rb')

require "bundler/setup"

require 'sinatra'
require 'rack/test'
require 'yaml'
require 'database_cleaner'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

@@app = Firefly::Server.new do
  set :hostname,        "test.host"
  set :api_key,         "test"
  set :database,        "sqlite3::memory:"

  set :sharing_key,     "asdfasdf"
  set :sharing_targets, [:twitter, :hyves, :facebook]
  set :sharing_domains, ["example.com", "example.net"]
end

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    Firefly::CodeFactory.create(:count => 0)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Firefly::CodeFactory.create(:count => 0)
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
