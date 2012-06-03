class ApplicationController < ActionController::Base

  # Force using the specified host in config/firefly.yml
  def default_url_options
    { host: Settings.host }
  end
end
