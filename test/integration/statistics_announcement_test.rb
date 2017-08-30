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
    assert page.has_css?('img[alt="National Statistics"]')
    assert_has_component_metadata_pair("Release date", "January 2016 (provisional)")
  end

  test "cancelled statistics" do
    setup_and_visit_content_item('cancelled_official_statistics')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    within '.app-c-notice' do
      assert page.has_text?('Statistics release cancelled'), "is cancelled"
      assert page.has_text?(@content_item["details"]["cancellation_reason"]), "displays cancelleation reason"
    end

    assert_has_component_metadata_pair("Proposed release", "20 January 2016 9:30am")
    assert_has_component_metadata_pair("Cancellation date", "17 January 2016 2:19pm")
  end

  test "statistics with a changed release date" do
    setup_and_visit_content_item('release_date_changed')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within '.primary-metadata' do
      assert_has_component_metadata_pair("Release date", "20 January 2016 9:30am (confirmed)")
    end

    within '.release-date-change-notice' do
      assert page.has_text?("The release date has been changed")
      assert_has_component_metadata_pair("Previous date", "19 January 2016 9:30am")
      assert_has_component_metadata_pair("Reason for change", @content_item["details"]["latest_change_note"])
    end
  end
end
