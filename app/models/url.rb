class Url < ActiveRecord::Base
  attr_accessible :url

  after_create :set_fingerprint

  private
  def set_fingerprint
    update_attribute(:fingerprint, self.id.to_s)
  end
end
