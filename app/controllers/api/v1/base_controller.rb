module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, :with => :rescue_not_found

      protected
      def rescue_not_found
        render nothing: true, status: :not_found
      end
    end
  end
end
