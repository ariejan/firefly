if ENV['RACK_ENV'] == "test"
  require 'rspec/core'
  require 'rspec/core/rake_task'

  task :default => :spec

  desc "Run all specs in spec directory (excluding plugin specs)"
  RSpec::Core::RakeTask.new(:spec)
end


require 'sinatra/activerecord/rake'
require File.expand_path('../lib/firefly', __FILE__)
