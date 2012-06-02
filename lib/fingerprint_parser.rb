require 'uri'

class FingerprintParser
  class << self
    def extract_fingerprint(*args)
      element = args.find { |el| el.present? }
      match_for_fingerprint(element)
    end

    private
    def match_for_fingerprint(element)
      if element.try(:match, URI.regexp(['http', 'https']))
        return URI.parse(element).path.gsub(/\//, '')
      else
        return element
      end
    end
  end
end
