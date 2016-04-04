module Web::Controllers::Items
  class Qrcode
    include Web::Action

    cache_control :private, max_age: 90

    def call(params)
    	self.format = :png

      @item = ItemRepository.find_by_code(params[:code])
      ClickRepository.register_for(@item)      
      @qr = RQRCode::QRCode.new(@item.short_url)

      self.body = @qr.as_png(size: 240).to_s
    end
  end
end
