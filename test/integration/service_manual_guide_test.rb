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

  test "service manual guide shows change history" do
    setup_and_visit_content_item('with_change_history')
    within ".change-history" do
      within ".change-history-published-by" do
        assert page.has_content? "Agile delivery community"
      end

      expected_timestamps = ["09 October 2015", "09 January 2016"]
      timestamps = all(".change-history-public-timestamp").map(&:text)
      assert_equal expected_timestamps, timestamps

      expected_notes = ["This is a change", "This is another change"]
      notes = all(".change-history-note").map(&:text)
      assert_equal expected_notes, notes
    end
  end
end
