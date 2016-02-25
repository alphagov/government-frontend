require 'test_helper'

class ServiceManualGuideTest < ActionDispatch::IntegrationTest
  test "service manual guide shows content owners" do
    setup_and_visit_content_item('basic_with_related_discussions')

    within('.metadata') do
      assert page.has_link?('Agile delivery community')
    end
  end
end
