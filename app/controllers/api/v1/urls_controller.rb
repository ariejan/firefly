module Api
  module V1
    class UrlsController < BaseController

      # /api/v1/expand
      def expand
        render nothing: true, status: :not_found
      end
    end
  end
end
