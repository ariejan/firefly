require 'rake'
require 'hanami/rake_tasks'
require 'rake/testtask'
require 'securerandom'

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.libs    << 'spec'
end

task default: :test
task spec: :test

desc "Generate a session secret or other secure token"
task :secret do
  puts SecureRandom.hex(32)
end
