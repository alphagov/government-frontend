require 'presenter_test_helper'

class StatisticalDataSetPresenterTest
  class StatisticalDataSetTestCase < PresenterTestCase
    def format_name
      "statistical_data_set"
    end
  end

  class PresentedStatisticalDataSet < StatisticalDataSetTestCase
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

  class WithdrawnStatisticalDataSet < StatisticalDataSetTestCase
    def example_schema_name
      "statistical_data_set_withdrawn"
    end

    def expected
      schema_item(example_schema_name)
    end

    def presented
      presented_item(example_schema_name)
    end

    test 'presents the withdrawn notice explanation' do
      assert_equal expected["withdrawn_notice"]["explanation"], presented.withdrawal_notice[:explanation]
    end

    test 'presents the withdrawn notification time' do
      expected_time = expected["withdrawn_notice"]["withdrawn_at"]
      expected_date_as_string = I18n.l(
        Date.parse(expected_time),
        format: "%-d %B %Y"
      )
      expected_withdrawn_time_html = "<time datetime=\"#{expected_time}\">#{expected_date_as_string}</time>"

      assert_equal expected_withdrawn_time_html, presented.withdrawal_notice[:time]
    end
  end

  class PoliticalStatisticalDataSet < StatisticalDataSetTestCase
    def example_schema_name
      "statistical_data_set_political"
    end

    def expected
      schema_item(example_schema_name)
    end

    def presented
      presented_item(example_schema_name)
    end

    test 'presents the political fields' do
      assert_equal expected["details"]["political"], presented.historically_political?
      assert_equal expected["details"]["government"]["title"], presented.publishing_government
    end
  end
end
