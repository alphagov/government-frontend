require 'presenter_test_helper'

class DetailedGuidePresenterTest < PresenterTest
  def format_name
    "detailed_guide"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item['description'], presented_item.description
    assert_equal schema_item['format'], presented_item.format
    assert_equal schema_item['title'], presented_item.title
    assert_equal schema_item['details']['body'], presented_item.body
  end

  test 'presents a list of contents extracted from headings in the body' do
    assert_equal '<a href="#the-basics">The basics</a>', presented_item.contents[0]
  end

  test '#published returns a formatted date of the day the content item became public' do
    assert_equal '12 June 2014', presented_item.published
  end

  test 'breadcrumbs show the full parent hierarchy' do
    assert_equal "Home", presented_item.breadcrumbs[0][:title]
    assert_equal "/", presented_item.breadcrumbs[0][:url]
    assert_equal "Business tax", presented_item.breadcrumbs[1][:title]
    assert_equal "/topic/business-tax", presented_item.breadcrumbs[1][:url]
    assert_equal "PAYE", presented_item.breadcrumbs[2][:title]
    assert_equal "/topic/business-tax/paye", presented_item.breadcrumbs[2][:url]
  end

  test 'no breadcrumbs show if there is no parent' do
    assert_equal [], presented_item("withdrawn_detailed_guide").breadcrumbs
  end

  test 'presents withdrawn notices' do
    example = schema_item("withdrawn_detailed_guide")
    presented = presented_item("withdrawn_detailed_guide")

    assert example["details"].include?("withdrawn_notice")
    assert presented.withdrawn?
    assert_equal example["details"]["withdrawn_notice"]["explanation"], presented.withdrawal_notice[:explanation]
    assert_equal '<time datetime="2015-01-28T13:05:30Z">28 January 2015</time>', presented.withdrawal_notice[:time]
  end
end
