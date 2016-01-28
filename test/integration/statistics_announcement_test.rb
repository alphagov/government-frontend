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

  def assert_has_component_metadata_pair(label, value)
    within shared_component_selector("metadata") do
      # Flatten top level / "other" args, for consistent hash access
      component_args = JSON.parse(page.text).tap do |args|
        args.merge!(args.delete("other"))
      end
      assert_equal value, component_args.fetch(label)
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
