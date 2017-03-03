require 'presenter_test_helper'

class SpecialistDocumentPresenterTest
  class SpecialistDocumentTestCase < PresenterTestCase
    def format_name
      "specialist_document"
    end
  end

  class PresentedSpecialistDocument < SpecialistDocumentTestCase
    test 'presents the format' do
      assert_equal schema_item('aaib-reports')['schema_name'], presented_item('aaib-reports').format
    end

    test 'presents the body' do
      expected_body = schema_item('aaib-reports')['details']['body']

      assert_equal expected_body, presented_item('aaib-reports').body
    end

    test 'has metadata' do
      assert presented_item('aaib-reports').is_a?(Metadata)
    end

    test 'has contents list' do
      assert presented_item('aaib-reports').is_a?(ContentsList)
    end

    test 'presents the published date using the oldest date in the change history' do
      example = schema_item('aaib-reports')
      example["first_published_at"] = "2001-01-01"
      example["details"]["change_history"] = [
        {
          "note" => "Newer",
          "public_timestamp" => "2003-03-03"
        },
        {
          "note" => "Oldest",
          "public_timestamp" => "2002-02-02"
        },
        {
          "note" => "More recent",
          "public_timestamp" => "2013-03-03"
        },
      ]

      presented = present_example(example)
      assert DateTime.parse(presented.published) == DateTime.parse("2002-02-02")
    end

    test 'has title without context' do
      assert presented_item('aaib-reports').is_a?(TitleAndContext)
      title_component_params = {
                                  title: schema_item('aaib-reports')['title'],
                                  average_title_length: 'long'
                               }

      assert_equal title_component_params, presented_item('aaib-reports').title_and_context
    end
  end
end
