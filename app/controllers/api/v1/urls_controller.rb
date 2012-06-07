module Api
  module V1
    class UrlsController < BaseController
      # /api/v1/shorten
      def shorten
        @url = Url.find_or_initialize_by_url(url: params[:long_url])

        if !@url.save
          render nothing: true, status: :not_acceptable
        end
      end

      # /api/v1/expand
      def expand
        fingerprint = FingerprintParser.extract_fingerprint(params[:fingerprint], params[:short_url])
        @url = Url.find_by_fingerprint!(fingerprint)
      end
    end
  end
end
