module Firefly
  class Database
    def self.connect!
      ActiveRecord::Base.establish_connection(config)
    end

    def self.config(file = 'config/database.yml')
      YAML::load(File.read(File.join(Firefly.root, file)))[Firefly.environment]
    end
  end
end

Firefly::Database.connect!
