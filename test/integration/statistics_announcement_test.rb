require 'test_helper'

class StatisticsAnnouncementTest < ActionDispatch::IntegrationTest
  test "official statistics" do
    setup_and_visit_content_item('official_statistics')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    within shared_component_selector("metadata") do
      assert page.has_text?('20 January 2016 9:30am (confirmed)'), "displays a confirmed release date"
      assert page.has_text?('Release date'), "is laballed with a release date"
    end
  end

  test "national statistics" do
    setup_and_visit_content_item('national_statistics')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_css?('.national-statistics-logo img')

    within shared_component_selector("metadata") do
      assert page.has_text?('January 2016 (provisional)'), "displays a provisional release date"
      assert page.has_text?('Release date'), "is laballed with a release date"
    end
  end

  test "cancelled statistics" do
    setup_and_visit_content_item('cancelled_official_statistics')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    within '.cancellation-notice' do
      assert page.has_text?('Statistics release cancelled'), "is cancelled"
      assert page.has_text?(@content_item["details"]["cancellation_reason"]), "displays cancelleation reason"
    end

    within shared_component_selector("metadata") do
      assert page.has_text?('20 January 2016 9:30am'), "displays the proposed release date"
      assert page.has_text?('Proposed release'), "is laballed 'proposed release'"
      assert page.has_text?('17 January 2016 2:19pm'), "displays the cancellation date"
      assert page.has_text?('Cancellation date'), "is laballed as cancelled'"
    end
  end

  def assert_has_component_title(title)
    within shared_component_selector("title") do
      assert_equal title, JSON.parse(page.text).fetch("title")
    end
  end

  def setup_and_visit_content_item(name)
    @content_item = JSON.parse(get_content_example(name)).tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      visit item["base_path"]
    end
  end

  def get_content_example(name)
    GovukContentSchemaTestHelpers::Examples.new.get('statistics_announcement', name)
  end
end
