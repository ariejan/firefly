# encoding: UTF-8
module Firefly
  class Base62

    CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split('')
    BASE = 62

    def self.encode(value)
      s = ""
      while value > 0
        value, rem = value.divmod(BASE)
        s << CHARS[rem]
      end
      s.reverse
    end

    def self.decode(str)
      total = 0
      str.split('').reverse.each_with_index do |v,k|
        total += (CHARS.index(v) * (BASE ** k))
      end
      total
    end
  end
end
