class UrlsController < ApplicationController

  # GET /:fingerprint
  def redirect
    @url = Url.find_by_fingerprint(params[:fingerprint])

    if @url
      redirect_to @url.url, status: :moved_permanently
    else
      render text: t(:url_not_found), status: :not_found
    end
  end
end
