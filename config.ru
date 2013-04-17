require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require File.expand_path('../lib/firefly', __FILE__)

disable :run

map(ENV['RACK_RELATIVE_URL_ROOT'] || '/') do
  run Firefly::Server.new
end
