module Firefly
  class Base62
  
    CHARS = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split('')
    BASE = 62
  
    def self.encode(value)
      s = []
      while value >= BASE
        value, rem = value.divmod(BASE)
        s << CHARS[rem]
      end
      s << CHARS[value]
      s.reverse.to_s
    end

    def self.decode(str)
      str = str.split('').reverse
      total = 0
      str.each_with_index do |v,k|
        total += (CHARS.index(v) * (BASE ** k))
      end
      total
    end
  end
end