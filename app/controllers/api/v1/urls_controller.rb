module Api
  module V1
    class UrlsController < BaseController

      # /api/v1/expand
      def expand
        @url = Url.find_by_fingerprint!(params[:fingerprint])
      end

    end
  end
end
