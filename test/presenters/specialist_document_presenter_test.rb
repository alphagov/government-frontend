require 'presenter_test_helper'

class SpecialistDocumentPresenterTest
  class SpecialistDocumentTestCase < PresenterTestCase
    def schema_name
      "specialist_document"
    end
  end

  class PresentedSpecialistDocument < SpecialistDocumentTestCase
    test 'presents the schema name' do
      assert_equal schema_item('aaib-reports')['schema_name'], presented_item('aaib-reports').schema_name
    end

    test 'presents the body' do
      expected_body = schema_item('aaib-reports')['details']['body']

      assert_equal expected_body, presented_item('aaib-reports').body
    end

    test 'has metadata' do
      assert presented_item('aaib-reports').is_a?(Metadata)
    end

    test 'presents headers as nested contents' do
      expected_headers = schema_item('aaib-reports')['details']['headers']
      assert_equal expected_headers, presented_item('aaib-reports').nested_contents
    end

    test 'presents updates based on change history' do
      example = schema_item('aaib-reports')
      example["details"]["change_history"] = [
        {
          "note" => "First published",
          "public_timestamp" => "2003-03-03"
        }
      ]

      refute present_example(example).updated

      example["details"]["change_history"] = [
        {
          "note" => "First published",
          "public_timestamp" => "2003-03-03"
        },
        {
          "note" => "Modified since first published",
          "public_timestamp" => "2013-04-05"
        }
      ]

      assert present_example(example).updated
    end

    test 'presents the published date using the oldest date in the change history (when no first published facet)' do
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

    test 'should not present continuation_link' do
      assert_equal(presented_item('aaib-reports').continuation_link, nil)
    end

    test 'should not present will_continue_on' do
      assert_equal(presented_item('aaib-reports').will_continue_on, nil)
    end

    test 'should present continuation_link' do
      assert_equal(
        presented_item('business-finance-support-scheme').continuation_link,
        'http://www.bigissueinvest.com'
      )
    end

    test 'should present will_continue_on' do
      assert_equal(
        presented_item('business-finance-support-scheme').will_continue_on,
        'on the Big Issue Invest website'
      )
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

    test 'includes non-filterable facet as text in metadata and document footer' do
      values = { "facet-key" => "document-value" }
      example = example_with_finder_facets([example_facet], values)

      presented = present_example(example)
      assert_equal "document-value", presented.metadata[:other]["Facet name"]
      assert_equal "document-value", presented.document_footer[:other]["Facet name"]
    end

    test 'includes friendly label for facet value in metadata and document footer' do
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

      presented = present_example(example)
      assert_equal "Document value from label", presented.metadata[:other]["Facet name"]
      assert_equal "Document value from label", presented.document_footer[:other]["Facet name"]
    end

    test 'falls back to provided value if value not found in allowed list' do
      overrides = {
        "allowed_values" => [
          {
            "label" => "Document value from label",
            "value" => "document-value"
          }
        ]
      }

      values = { "facet-key" => "not-an-allowed-value" }
      example = example_with_finder_facets([example_facet(overrides)], values)

      Airbrake.expects(:notify).twice.with('Facet value not in list of allowed values',
        error_message: "Facet value 'not-an-allowed-value' not an allowed value for facet 'Facet name' on /aaib-reports/aaib-investigation-to-rotorsport-uk-calidus-g-pcpc content item")

      presented = present_example(example)
      assert_equal "not-an-allowed-value", presented.metadata[:other]["Facet name"]
      assert_equal "not-an-allowed-value", presented.document_footer[:other]["Facet name"]
    end

    test 'ignores facets in metadata if not a valid finder facet' do
      values = { "random-invalid-facet" => "something-odd" }
      example = example_with_finder_facets([example_facet], values)

      presented = present_example(example)
      assert_empty presented.metadata[:other]
      assert_empty presented.document_footer[:other]
    end

    test 'ignores facets if valid key but set to an empty string' do
      example = example_with_finder_facets([
                                              {
                                                "name" => "Facet name",
                                                "key" => "facet-key",
                                                "type" => "text",
                                              },
                                              {
                                                "name" => "Date facet",
                                                "key" => "date-facet",
                                                "type" => "date",
                                              }
                                            ],
                                            "facet-key" => "",
                                            "date-facet" => ""
                                          )

      assert_empty present_example(example).metadata[:other]
    end

    test 'passes array of multiple values to metadata and document_footer components' do
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

      presented = present_example(example)
      assert_equal %w{One Two}, presented.metadata[:other]["Facet name"]
      assert_equal %w{One Two}, presented.document_footer[:other]["Facet name"]
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

      presented = present_example(example)
      expected_link = "<a href=\"/finder-base-path?facet-key%5B%5D=something\">Something</a>"
      assert_equal expected_link, presented.metadata[:other]["Facet name"]
      assert_equal expected_link, presented.document_footer[:other]["Facet name"]
    end

    test 'includes friendly dates for date facets in metadata' do
      overrides = { "type" => "date" }
      values = { "facet-key" => "2010-01-01" }
      example = example_with_finder_facets([example_facet(overrides)], values)

      presented_metadata = present_example(example).metadata[:other]
      assert_equal "1 January 2010", presented_metadata["Facet name"]
    end

    test 'includes friendly dates in other_dates for date facets in document footer' do
      overrides = { "type" => "date" }
      values = { "facet-key" => "2010-01-01" }
      example = example_with_finder_facets([example_facet(overrides)], values)

      presented_metadata = present_example(example).document_footer[:other_dates]
      assert_equal "1 January 2010", presented_metadata["Facet name"]
    end

    test 'puts date facets together and before text facets' do
      example = example_with_finder_facets([
                                            {
                                              "name" => "Facet name",
                                              "key" => "facet-key",
                                              "type" => "text",
                                            },
                                            {
                                              "name" => "First date facet",
                                              "key" => "first-date-facet",
                                              "type" => "date",
                                            },
                                            {
                                              "name" => "Second date facet",
                                              "key" => "second-date-facet",
                                              "type" => "date",
                                            },
                                            {
                                              "name" => "More text",
                                              "key" => "more-text",
                                              "type" => "text",
                                            }
                                          ],
                                            "facet-key" => "Text",
                                            "first-date-facet" => "2010-01-01",
                                            "second-date-facet" => "2010-02-03",
                                            "more-text" => "More text"
                                        )

      expected_order = ["First date facet", "Second date facet", "Facet name", "More text"]
      assert_equal expected_order, present_example(example).metadata[:other].keys
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

    test 'sends an Airbrake notification when there is no finder' do
      example = schema_item('aaib-reports')
      example['links']['finder'] = []

      Airbrake.expects(:notify).with('Finder not found',
        error_message: 'Finder not found in /aaib-reports/aaib-investigation-to-rotorsport-uk-calidus-g-pcpc content item')

      present_example(example).metadata
    end

    test 'no breadcrumbs render with no finder' do
      example = schema_item('aaib-reports')
      example['links']['finder'] = []
      assert_equal [], present_example(example).breadcrumbs

      example['links'].delete('finder')
      assert_equal [], present_example(example).breadcrumbs
    end

    test 'omits first_published_at facet values from `other` section of component parameters to avoid duplicates' do
      facets = [
                  {
                    "name" => "Published",
                    "key" => "first_published_at",
                    "type" => "date",
                  }
                ]
      example = example_with_finder_facets(facets, "first_published_at" => "2010-01-01")

      presented = present_example(example)
      refute presented.document_footer[:other_dates]['Published']
      refute presented.metadata[:other]['Published']
    end

    test 'uses first published date in facets as canonical publish date if provided' do
      facets = [
                  {
                    "name" => "Published",
                    "key" => "first_published_at",
                    "type" => "date",
                  }
                ]
      example = example_with_finder_facets(facets, "first_published_at" => "2010-01-01")

      example["details"]["change_history"] = [
        {
          "note" => "A date in the change history",
          "public_timestamp" => "2002-02-02"
        },
      ]

      presented = present_example(example)
      assert DateTime.parse(presented.published) == DateTime.parse("2010-01-01")
    end
  end
end
