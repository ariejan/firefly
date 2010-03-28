require File.join(File.dirname(__FILE__), '..', 'lib', 'firefly.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'spec'
require 'spec/autorun'
require 'spec/interop/test'

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

set :hostname, 'test.host'
set :api_key,  'test'

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
end