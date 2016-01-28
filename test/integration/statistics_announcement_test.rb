require 'test_helper'

class StatisticsAnnouncementTest < ActionDispatch::IntegrationTest
  test "official statistics" do
    setup_and_visit_content_item('official_statistics')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_metadata_pair("Release date", "20 January 2016 9:30am (confirmed)")
  end

  test "national statistics" do
    setup_and_visit_content_item('national_statistics')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_css?('.national-statistics-logo img')
    assert_has_component_metadata_pair("Release date", "January 2016 (provisional)")
  end

  test "cancelled statistics" do
    setup_and_visit_content_item('cancelled_official_statistics')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    within '.cancellation-notice' do
      assert page.has_text?('Statistics release cancelled'), "is cancelled"
      assert page.has_text?(@content_item["details"]["cancellation_reason"]), "displays cancelleation reason"
    end

    assert_has_component_metadata_pair("Proposed release", "20 January 2016 9:30am")
    assert_has_component_metadata_pair("Cancellation date", "17 January 2016 2:19pm")
  end
end
