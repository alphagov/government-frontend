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

  test "service manual guide shows latest change history" do
    setup_and_visit_content_item('with_change_history')
    within ".change-history" do
      within ".change-history-published-by" do
        assert page.has_content? "Agile delivery community"
      end

      notes = all(".change-history-note").map(&:text)
      assert_includes notes, "This is a change"

      reasons = all(".change-history-reason").map(&:text)
      assert_includes reasons, "This is our latest change"

      timestamps = all(".change-history-public-timestamp").map(&:text)
      assert_includes timestamps, "09 October 2017"
    end
  end

  test "service manual guide hides older change history" do
    setup_and_visit_content_item('with_change_history')

    module_container = find(".change-history")
    assert_equal "toggle", module_container["data-module"]
    assert_equal "toggle", module_container["data-module"]

    hidden_container = find(".change-history #change-history-hidden")
    assert_equal "js-hidden", hidden_container["class"]

    expand_link = find(".change-history a", text: "+ full page history")
    assert_equal "false", expand_link["data-expanded"]
    assert_equal "change-history-hidden", expand_link["data-controls"]

    within ".change-history #change-history-hidden" do
      notes = all(".change-history-note").map(&:text)
      assert_includes notes, "This is another change"

      reasons = all(".change-history-reason").map(&:text)
      assert_includes reasons, "This is why we made this change and it has a second line of text"

      timestamps = all(".change-history-public-timestamp").map(&:text)
      assert_includes timestamps, "09 January 2016"
    end
  end
end
