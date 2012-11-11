# encoding: UTF-8
module Firefly
  class CodeFactory

    # Returns the next auto increment value and updates
    # the counter
    def self.next_code!
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
