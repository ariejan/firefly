require 'rspec/core/rake_task'
require 'sinatra/activerecord/rake'
require './lib/firefly'

desc "Run all the specs!"
RSpec::Core::RakeTask.new :spec do |config|
  ENV['RACK_ENV'] = "test"
end

task default: :spec

