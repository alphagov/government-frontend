class ApplicationController < ActionController::Base
  include Slimmer::GovukComponents

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery except: :service_sign_in_options

  def current_tasklist_ab_test
    GovukNavigationHelpers::CurrentTasklistAbTest.new(
      current_tasklist: current_tasklist,
      request: request
    )
  end
  helper_method :current_tasklist_ab_test

private

  def current_tasklist
    GovukNavigationHelpers::TasklistContent.current_tasklist(request.path)
  end

  def content_item_path
    path_and_optional_locale = params
                                 .values_at(:path, :locale)
                                 .compact
                                 .join('.')

    '/' + URI.encode(path_and_optional_locale)
  end
end
