# encoding: UTF-8
module Firefly
  class CodeFactory
    class << self
      attr_accessor :order
    end

    include DataMapper::Resource

    property :id,    Serial
    property :count, Integer, :default => 0

    # Redirect to the selected order method
    def self.next_code!
      self.send("next_#{self.order || :sequential}_code!".to_sym)
    end

    # Returns the next value randomly
    def self.next_random_code!
      Firefly::Base62.encode(rand(200000000))
    end

    # Returns the next auto increment value and updates
    # the counter
    def self.next_sequential_code!
      code = nil

      Firefly::CodeFactory.transaction do
        c = Firefly::CodeFactory.first
        code = Firefly::Base62.encode(c.count + 1)
        c.update(:count => c.count + 1)
      end

      code
    end

  end
end
