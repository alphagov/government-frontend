class ApplicationController < ActionController::Base
  include Slimmer::GovukComponents

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery except: :service_sign_in_options

private

  def step_nav_helper
    @step_nav_helpers ||= GovukPublishingComponents::StepNavHelper.new(content_item.content_item, request.path)
  end
  helper_method :step_nav_helper

  def content_item_path
    path_and_optional_locale = params
                                 .values_at(:path, :locale)
                                 .compact
                                 .join('.')

    '/' + URI.encode(path_and_optional_locale)
  end
end
