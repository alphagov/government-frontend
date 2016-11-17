require 'presenter_test_helper'

class StatisticalDataSetPresenterTest
  class PresentedStatisticalDataSet < PresenterTestCase
    def format_name
      "statistical_data_set"
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end

    test 'presents a list of contents extracted from headings in the body' do
      assert_equal '<a href="#olympics">Olympics</a>', presented_item.contents[0]
    end

    test '#published returns a formatted date of the day the content item became public' do
      assert_equal "13 December 2012", presented_item.published
    end

    test 'presents a description' do
      assert_equal schema_item["description"], presented_item.description
    end

    test 'presents the body' do
      expected_body = schema_item['details']['body']

      assert_equal expected_body, presented_item.body
    end
  end
end
