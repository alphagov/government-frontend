class ApplicationController < ActionController::Base
  include Slimmer::GovukComponents

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery except: :service_sign_in_options

private

  def current_step_nav
    @step_nav ||= GovukNavigationHelpers::StepNavContent.current_step_nav(request.path)
  end
  helper_method :current_step_nav

  def show_step_nav?
    current_step_nav && current_step_nav.show_step_nav?
  end
  helper_method :show_step_nav?

  def content_item_path
    path_and_optional_locale = params
                                 .values_at(:path, :locale)
                                 .compact
                                 .join('.')

    '/' + URI.encode(path_and_optional_locale)
  end
end
