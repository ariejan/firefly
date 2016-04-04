module Admin::Controllers::Items
  class Qrcode
    include Admin::Action

    def call(params)
    	self.format = :png

      @item = ItemRepository.find(params[:id])
      @qr = RQRCode::QRCode.new(@item.short_url)

      self.body = @qr.as_png(size: 240).to_s
    end
  end
end
