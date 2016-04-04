require './config/environment'
require 'sidekiq/web'

map '/admin/sidekiq' do
  use Sidekiq::Web
end

run Hanami::Container.new
