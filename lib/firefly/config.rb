# encoding: UTF-8
module Firefly
  class Config < Hash

    DEFAULTS = {
      :hostname         => "localhost:3000",
      :api_key          => "test",
      :database         => "sqlite3://#{Dir.pwd}/firefly_#{ENV['RACK_ENV']}.sqlite3",
      :recent_urls      => 25,
      :twitter          => "Check this out: %short_url%",
      :hyves_path       => "toevoegen/tips",
      :hyves_args       => "type=12&rating=5",
      :hyves_title      => "Check this out",
      :hyves_body       => "Check this out: %short_url%",
      :qr_size          => "150x150"
    }

    def initialize obj
      self.update DEFAULTS
      self.update obj
    end

    def set key, val = nil, &blk
      if val.is_a? Hash
        self[key].update val
      else
        self[key] = block_given?? blk : val
      end
    end
  end
end
