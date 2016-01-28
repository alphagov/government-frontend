require 'test_helper'

class StatisticsAnnouncementTest < ActionDispatch::IntegrationTest
  test "official statistics" do
    item = GovukContentSchemaTestHelpers::Examples.new.get('statistics_announcement', 'official_statistics')
    content_store_has_item("/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015--2", item)

    visit "/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015--2"

    assert page.has_text?('Diagnostic imaging dataset for September 2015')
  end

  test "national statistics" do
    item = GovukContentSchemaTestHelpers::Examples.new.get('statistics_announcement', 'national_statistics')
    content_store_has_item("/government/statistics/announcements/uk-armed-forces-quarterly-personnel-report-october-2015", item)

    visit "/government/statistics/announcements/uk-armed-forces-quarterly-personnel-report-october-2015"

    assert page.has_text?('UK armed forces quarterly personnel report: 1 October 2015')
    assert page.has_css?('.national-statistics-logo img')
  end

  test "cancelled statistics" do
    item = GovukContentSchemaTestHelpers::Examples.new.get('statistics_announcement', 'cancelled_official_statistics')
    content_store_has_item("/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015", item)

    visit "/government/statistics/announcements/diagnostic-imaging-dataset-for-september-2015"

    assert page.has_text?('Diagnostic imaging dataset for September 2015')
    assert page.has_text?('Statistics release cancelled'), "is cancelled"
  end
end
