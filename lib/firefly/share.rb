module Firefly
  module Share
    def twitter(url, message = nil)
      status = if message.nil? || message == ""
        config[:twitter].gsub('%short_url%', url)
      else
        max_length = 140-1-url.size
        [message.strip.slice(0...max_length), url].join(' ')
      end
      "http://twitter.com/home?status=#{URI.escape(status)}" 
    end

    def hyves(url, title = nil, body = nil)
      if title.nil? || title == ""
        title = config[:hyves_title]
      end

      if body.nil? || body == ""
       body = config[:hyves_body].gsub('%short_url%', url)
      end

      "http://www.hyves.nl/profielbeheer/#{config[:hyves_path]}/?name=#{title.strip}&text=#{body.strip}&#{config[:hyves_args]}"
    end

    def facebook(url)
      "http://www.facebook.com/share.php?u=#{url}"
    end
  end
end
