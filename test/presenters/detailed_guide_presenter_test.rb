require 'presenter_test_helper'

class DetailedGuidePresenterTest < PresenterTest

  test 'presents the basic details of a content item' do

    assert_equal example['description'], presented_example.description
    assert_equal example['format'], presented_example.format
    assert_equal example['title'], presented_example.title
    assert_equal example['details']['body'], presented_example.body
  end

  test 'presents a list of contents extracted from headings in the body' do
    presented_example = presented_example_content_item('detailed_guide')
    assert_equal '<a href="#the-basics">The basics</a>', presented_example.contents[0]
  end

  test '#published returns a formatted date of the day the content item became public' do
    assert_equal '18 February 2016', presented_example.published
  end

  def format_name
    "detailed_guide"
  end

  def example
    example_content_item(format_name)
  end

  def presented_example
    presented_example_content_item(format_name)
  end
end
