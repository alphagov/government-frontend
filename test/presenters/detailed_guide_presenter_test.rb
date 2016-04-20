require 'presenter_test_helper'

class DetailedGuidePresenterTest < PresenterTest
  test 'presents the basic details of a content item' do
    assert_equal example_content_item['description'], presented_example_content_item.description
    assert_equal example_content_item['format'], presented_example_content_item.format
    assert_equal example_content_item['title'], presented_example_content_item.title
    assert_equal example_content_item['details']['body'], presented_example_content_item.body
  end

  test 'presents a list of contents extracted from headings in the body' do
    assert_equal '<a href="#the-basics">The basics</a>', presented_example_content_item.contents[0]
  end

  test '#published returns a formatted date of the day the content item became public' do
    assert_equal '12 June 2014', presented_example_content_item.published
  end

  test 'breadcrumbs show the full parent hierarchy' do
    assert_equal "Home", presented_example_content_item.breadcrumbs[0][:title]
    assert_equal "/", presented_example_content_item.breadcrumbs[0][:url]
    assert_equal "Business tax", presented_example_content_item.breadcrumbs[1][:title]
    assert_equal "/topic/business-tax", presented_example_content_item.breadcrumbs[1][:url]
    assert_equal "PAYE", presented_example_content_item.breadcrumbs[2][:title]
    assert_equal "/topic/business-tax/paye", presented_example_content_item.breadcrumbs[2][:url]
  end

  def format_name
    "detailed_guide"
  end
end
