class ApplicationController < ActionController::Base
  include Slimmer::Headers
  include Slimmer::SharedTemplates
  before_filter :set_slimmer_headers

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

private
  def set_expiry(max_age)
    cache_control_directive = GovernmentFrontend::Application.config.cache_control_directive
    return if cache_control_directive == 'no-cache'

    expires_in(max_age, public: cache_control_directive == 'public')
  end

  def set_slimmer_headers
    response.headers[Slimmer::Headers::TEMPLATE_HEADER] = "core_layout"
  end
end
