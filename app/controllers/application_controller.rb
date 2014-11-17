class ApplicationController < ActionController::Base
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
