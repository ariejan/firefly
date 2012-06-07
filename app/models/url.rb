require 'uri'

class Url < ActiveRecord::Base
  attr_accessible :url

  validates :url, format: { with: URI.regexp(['http', 'https']) }

  after_create :set_fingerprint

  private
  def set_fingerprint
    update_attribute(:fingerprint, self.id.to_s)
  end
end
