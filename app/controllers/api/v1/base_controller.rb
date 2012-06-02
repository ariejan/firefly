module Api
  module V1
    class BaseController < ActionController::Base
      respond_to :json
    end
  end
end
