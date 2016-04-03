require 'hanami/model'
require 'hanami/mailer'
Dir["#{ __dir__ }/firefly/**/*.rb"].each { |file| require_relative file }

Hanami::Model.configure do
  ##
  # Database adapter
  #
  # Available options:
  #
  #  * Memory adapter
  #    adapter type: :memory, uri: 'memory://localhost/firefly_development'
  #
  #  * SQL adapter
  #    adapter type: :sql, uri: 'sqlite://db/firefly_development.sqlite3'
  #    adapter type: :sql, uri: 'postgres://localhost/firefly_development'
  #    adapter type: :sql, uri: 'mysql://localhost/firefly_development'
  #
  adapter type: :sql, uri: ENV['FIREFLY_DATABASE_URL']

  ##
  # Migrations
  #
  migrations 'db/migrations'
  schema     'db/schema.sql'

  ##
  # Database mapping
  #
  # Intended for specifying application wide mappings.
  #
  # You can specify mapping file to load with:
  #
  # mapping "#{__dir__}/config/mapping"
  #
  # Alternatively, you can use a block syntax like the following:
  #
  mapping do
    collection :items do
      entity Item
      repository ItemRepository

      attribute :id,         Integer
      attribute :type,       String
      attribute :content,    String
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
    end

    collection :clicks do
      entity Click
      repository ClickRepository

      attribute :id,         Integer
      attribute :item_id,    Integer
      attribute :created_at, DateTime
    end
  end
end.load!

Hanami::Mailer.configure do
  root "#{ __dir__ }/firefly/mailers"

  # See http://hanamirb.org/guides/mailers/delivery
  delivery do
    development :test
    test        :test
    # production :stmp, address: ENV['SMTP_PORT'], port: 1025
  end
end.load!
