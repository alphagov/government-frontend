require 'test_helper'

class StatisticsAnnouncementTest < ActionDispatch::IntegrationTest
  test "official statistics" do
    setup_and_visit_content_item('official_statistics')

    assert page.has_text?('Diagnostic imaging dataset for September 2015')
  end

  test "national statistics" do
    setup_and_visit_content_item('national_statistics')

    assert page.has_text?('UK armed forces quarterly personnel report: 1 October 2015')
    assert page.has_css?('.national-statistics-logo img')
  end

  test "cancelled statistics" do
    setup_and_visit_content_item('cancelled_official_statistics')

    assert page.has_text?('Diagnostic imaging dataset for September 2015')
    assert page.has_text?('Statistics release cancelled'), "is cancelled"
  end

  def setup_and_visit_content_item(name)
    JSON.parse(get_content_example(name)).tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      visit item["base_path"]
    end
  end

  def get_content_example(name)
    GovukContentSchemaTestHelpers::Examples.new.get('statistics_announcement', name)
  end
end
