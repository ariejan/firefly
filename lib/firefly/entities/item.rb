class Item
  include Hanami::Entity
  attributes :type, :content, :title, :created_at, :updated_at

  def short_url
    "#{protocol}://#{domain}/#{code}"
  end

  def code
    Base62.encode(id)
  end

  def number_of_clicks
    ClickRepository.count_for(self)
  end

  def get_title
    title || content
  end

  private

  def protocol
    @protocol ||= ENV['FIREFLY_SSL_ENABLED'] == 'true' ? 'https' : 'http'
  end

  def domain
    @domain ||= ENV['FIREFLY_SHORT_TLD']
  end
end
