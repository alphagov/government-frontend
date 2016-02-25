require 'test_helper'

class ServiceManualGuideTest < ActionDispatch::IntegrationTest
  test "service manual guide shows content owners" do
    setup_and_visit_content_item('basic_with_related_discussions')

    within('.metadata') do
      assert page.has_link?('Agile delivery community')
    end
  end

  test "service manual guide does not show published by" do
    setup_and_visit_content_item('service_manual_guide_community')

    within('.metadata') do
      refute page.has_content?('Published by')
    end
  end
end
