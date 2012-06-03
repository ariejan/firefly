module Api
  module V1
    class UrlsController < BaseController
      # /api/v1/shorten
      def shorten
        @url = Url.create(url: params[:long_url])
      end

      # /api/v1/expand
      def expand
        fingerprint = FingerprintParser.extract_fingerprint(params[:fingerprint], params[:short_url])
        @url = Url.find_by_fingerprint!(fingerprint)
      end
    end
  end
end
