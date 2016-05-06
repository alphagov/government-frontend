require 'presenter_test_helper'

class PublicationPresenterTest < PresenterTest
  def format_name
    "publication"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item['description'], presented_item.description
    assert_equal schema_item['format'], presented_item.format
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

  test 'presents withdrawn notices' do
    example = schema_item("withdrawn_publication")
    presented = presented_item("withdrawn_publication")

    assert example["details"].include?("withdrawn_notice")
    assert presented.withdrawn?
    assert_equal example["details"]["withdrawn_notice"]["explanation"], presented.withdrawal_notice[:explanation]
    assert_equal '<time datetime="2015-01-13T13:05:30Z">13 January 2015</time>', presented.withdrawal_notice[:time]
  end
end
