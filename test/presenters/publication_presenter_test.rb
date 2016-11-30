require 'presenter_test_helper'

class PublicationPresenterTest < PresenterTestCase
  def format_name
    "publication"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item['description'], presented_item.description
    assert_equal schema_item['schema_name'], presented_item.format
    assert_equal schema_item['title'], presented_item.title
    assert_equal schema_item['details']['body'], presented_item.details
    assert_equal schema_item['details']['documents'].join(''), presented_item.documents
  end

  test '#published returns a formatted date of the day the content item became public' do
    assert_equal '3 May 2016', presented_item.published
  end

  test 'counts documents attached to publication' do
    assert_equal 2, presented_item.documents_count
  end

  test 'presents the title of the publishing government' do
    assert_equal schema_item["details"]["government"]["title"], presented_item.publishing_government
  end

  test 'content can be historically political' do
    example = schema_item("political_publication")
    presented = presented_item("political_publication")

    refute example["details"]["government"]["current"]
    assert example["details"]["political"]

    assert presented.historically_political?
  end

  test '#from presents ministers' do
    minister = schema_item["links"]["ministers"][0]
    assert presented_item.from.include?("<a href=\"#{minister['base_path']}\">#{minister['title']}</a>")
  end

  test '#part_of presents topical events' do
    event = schema_item["links"]["topical_events"][0]
    assert presented_item.part_of.include?("<a href=\"#{event['base_path']}\">#{event['title']}</a>")
  end

  test '#part_of presents related statistical data sets' do
    data_set = schema_item("statistics_publication")["links"]["related_statistical_data_sets"][0]
    assert presented_item("statistics_publication").part_of.include?("<a href=\"#{data_set['base_path']}\">#{data_set['title']}</a>")
  end

  test '#national_statistics? matches national statistics documents' do
    refute presented_item.national_statistics?
    assert presented_item("statistics_publication").national_statistics?
  end

  test 'presents withdrawn notices' do
    example = schema_item("withdrawn_publication")
    presented = presented_item("withdrawn_publication")

    assert example.include?("withdrawn_notice")
    assert presented.withdrawn?
    assert_equal example["withdrawn_notice"]["explanation"], presented.withdrawal_notice[:explanation]
    assert_equal '<time datetime="2015-01-13T13:05:30Z">13 January 2015</time>', presented.withdrawal_notice[:time]
  end

  test 'content can apply only to a set of nations (with alternative urls when provided)' do
    example = schema_item('statistics_publication')
    presented = presented_item('statistics_publication')

    assert example['details'].include?('national_applicability')
    assert_equal(
      presented.applies_to,
      'England (see publications for <a rel="external" href="http://www.dsdni.gov.uk/index/stats_and_research/stats-publications/stats-housing-publications/housing_stats.htm">Northern Ireland</a>, <a rel="external" href="http://www.scotland.gov.uk/Topics/Statistics/Browse/Housing-Regeneration/HSfS">Scotland</a>, and <a rel="external" href="http://wales.gov.uk/topics/statistics/headlines/housing2012/121025/?lang=en">Wales</a>)'
    )
  end
end
