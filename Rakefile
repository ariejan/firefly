require 'rspec/core'
require 'rspec/core/rake_task'
require 'sinatra/activerecord/rake'
require File.expand_path('../lib/firefly', __FILE__)

task :default => :spec

desc "Run all specs in spec directory (excluding plugin specs)"
RSpec::Core::RakeTask.new(:spec)
