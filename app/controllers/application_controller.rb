class ApplicationController < ActionController::Base
  include GovukNavigationHelpers::Tasklist::Helper
  include Slimmer::GovukComponents

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery prepend: true

private

  def set_up_traffic_signs_summary_ab_testing
    @traffic_signs_summary_ab_test = TrafficSignsSummaryAbTestRequest.new(
      request, @content_item.content_item
    )
    return unless @traffic_signs_summary_ab_test.ab_test_applies?

    @traffic_signs_summary_ab_test.set_response_vary_header response

    if @traffic_signs_summary_ab_test.should_present_old_summary?
      @content_item = @traffic_signs_summary_ab_test.with_old_summary(@content_item)
    end
  end

  def content_item_path
    path_and_optional_locale = params
                                 .values_at(:path, :locale)
                                 .compact
                                 .join('.')

    '/' + URI.encode(path_and_optional_locale)
  end
end
