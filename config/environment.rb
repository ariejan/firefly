require 'rubygems'
require 'bundler/setup'
require 'hanami/setup'
require_relative '../lib/firefly'
require_relative '../apps/admin/application'
require_relative '../apps/api/application'
require_relative '../apps/web/application'

# Sidekiq
require_relative '../lib/firefly'
require_relative '../apps/admin/application'
require_relative './sidekiq'

Hanami::Container.configure do
  mount Admin::Application, at: '/admin'
  mount Api::Application, at: '/api'
  mount Web::Application, at: '/'
end
