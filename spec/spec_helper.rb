require File.join(File.dirname(__FILE__), '..', 'lib', 'firefly.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'spec'
require 'spec/autorun'
require 'spec/interop/test'
require 'yaml'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

@@app = Firefly::Server.new do
  set :hostname,    "test.host"
  set :api_key,     "test"
  set :database,    "sqlite3://#{Dir.pwd}/firefly_test.sqlite3"
end

Spec::Runner.configure do |config|
  config.after(:each) do
      repository do |r|
        adapter = r.adapter
        while adapter.current_transaction
          adapter.current_transaction.rollback
          adapter.pop_transaction
        end
      end
  end

  config.before(:each)  do
      repository do |r|
        transaction = DataMapper::Transaction.new(r)
        transaction.begin
        r.adapter.push_transaction(transaction)
      end
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
