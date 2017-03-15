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

  class PresentedSpecialistDocumentWithFinderFacets < SpecialistDocumentTestCase
    def example_with_finder_facets(facets = [], values = {})
      example = schema_item('aaib-reports')
      example_finder = {
        "base_path" => "/finder-base-path",
        "title" => "Finder title",
        "details" => {
          "document_noun" => "case",
          "filter" => {
            "document_type" => "cma_case"
          },
          "format_name" => "Competition and Markets Authority case",
          "facets" => facets,
        },
      }

      example['details']['metadata'] = values
      example['links']['finder'] = [example_finder]
      example
    end

    def example_facet(overrides = {})
      {
        "name" => "Facet name",
        "key" => "facet-key",
        "type" => "text",
        "filterable" => false
      }.merge(overrides)
    end

    test 'includes non-filterable facet as text in metadata' do
      values = { "facet-key" => "document-value" }
      example = example_with_finder_facets([example_facet], values)

      presented_metadata = present_example(example).metadata[:other]
      assert_equal "document-value", presented_metadata["Facet name"]
    end

    test 'includes friendly label for facet value in metadata' do
      overrides = {
        "allowed_values" => [
          {
            "label" => "Document value from label",
            "value" => "document-value"
          }
        ]
      }

      values = { "facet-key" => "document-value" }
      example = example_with_finder_facets([example_facet(overrides)], values)

      presented_metadata = present_example(example).metadata[:other]
      assert_equal "Document value from label", presented_metadata["Facet name"]
    end

    test 'handles multiple values for facets' do
      overrides = {
        "allowed_values" => [
          {
            "label" => "One",
            "value" => "one"
          },
          {
            "label" => "Two",
            "value" => "two"
          }
        ]
      }

      values = { "facet-key" => %w{one two} }
      example = example_with_finder_facets([example_facet(overrides)], values)

      presented_metadata = present_example(example).metadata[:other]
      assert_equal "One, Two", presented_metadata["Facet name"]
    end

    test 'creates links for filterable friendly values' do
      overrides = {
        "filterable" => true,
        "allowed_values" => [
          {
            "label" => "Something",
            "value" => "something"
          }
        ]
      }

      values = { "facet-key" => "something" }
      example = example_with_finder_facets([example_facet(overrides)], values)

      presented_metadata = present_example(example).metadata[:other]
      assert_equal "<a href=\"/finder-base-path?facet-key%5B%5D=something\">Something</a>", presented_metadata["Facet name"]
    end

    test 'includes friendly dates for date facets in metadata' do
      overrides = { "type" => "date" }
      values = { "facet-key" => "2010-01-01" }
      example = example_with_finder_facets([example_facet(overrides)], values)

      presented_metadata = present_example(example).metadata[:other]
      assert_equal "1 January 2010", presented_metadata["Facet name"]
    end

    test 'breadcrumbs' do
      assert_equal [
        {
          title: "Home",
          url: "/"
        },
        {
          title: "Finder title",
          url: "/finder-base-path"
        }
      ], present_example(example_with_finder_facets).breadcrumbs
    end

    test 'no breadcrumbs render with no finder' do
      example = schema_item('aaib-reports')
      example['links']['finder'] = []
      assert_equal [], present_example(example).breadcrumbs

      example['links'].delete('finder')
      assert_equal [], present_example(example).breadcrumbs
    end
  end
end
