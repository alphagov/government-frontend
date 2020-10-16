require "presenter_test_helper"

class SpecialistDocumentPresenterTest
  class SpecialistDocumentTestCase < PresenterTestCase
    def schema_name
      "specialist_document"
    end
  end

  class PresentedSpecialistDocument < SpecialistDocumentTestCase
    test "presents the schema name" do
      assert_equal schema_item("aaib-reports")["schema_name"], presented_item("aaib-reports").schema_name
    end

    test "presents the body" do
      expected_body = schema_item("aaib-reports")["details"]["body"]

      assert_equal expected_body, presented_item("aaib-reports").body
    end

    test "presents the protection_type when specialist document's schema is 'protected-food-drink-names'" do
      protection_type = "protected-designation-of-origin-pdo"

      assert_equal protection_type, presented_item("protected-food-drink-names").protection_type
      assert_equal protection_type, schema_item("protected-food-drink-names")["details"]["metadata"]["protection_type"]
    end

    test "does not present the protection_type when specialist document's schema is not 'protected-food-drink-names'" do
      assert_nil schema_item("aaib-reports")["details"]["metadata"]["protection_type"]
      assert_nil presented_item("aaib-reports").protection_type
    end

    test "has metadata" do
      assert presented_item("aaib-reports").is_a?(ContentItem::Metadata)
    end

    test "presents headers as nested contents (with trailing colons removed)" do
      expected_headers = [
        { text: "Reports of diabetic acidosis", id: "reports-of-diabetic-acidosis", href: "#reports-of-diabetic-acidosis" },
        { text: "SGLT2 inhibitors – medicines in this class", id: "sglt2-inhibitors--medicines-in-this-class", href: "#sglt2-inhibitors--medicines-in-this-class" },
        { text: "Further information", id: "further-information", href: "#further-information" },
      ]

      assert_equal expected_headers, presented_item("drug-safety-update").contents
    end

    test "presents updates based on change history" do
      example = schema_item("aaib-reports")
      example["details"]["change_history"] = [
        {
          "note" => "First published",
          "public_timestamp" => "2003-03-03",
        },
      ]

      assert_not present_example(example).updated

      example["details"]["change_history"] = [
        {
          "note" => "First published",
          "public_timestamp" => "2003-03-03",
        },
        {
          "note" => "Modified since first published",
          "public_timestamp" => "2013-04-05",
        },
      ]

      assert present_example(example).updated
    end

    test "presents the published date using the oldest date in the change history (when no first published facet)" do
      example = schema_item("aaib-reports")
      example["first_published_at"] = "2001-01-01"
      example["details"]["change_history"] = [
        {
          "note" => "Newer",
          "public_timestamp" => "2003-03-03",
        },
        {
          "note" => "Oldest",
          "public_timestamp" => "2002-02-02",
        },
        {
          "note" => "More recent",
          "public_timestamp" => "2013-03-03",
        },
      ]

      presented = present_example(example)
      assert Time.zone.parse(presented.published) == Time.zone.parse("2002-02-02")
    end

    test "has title without context" do
      assert presented_item("aaib-reports").is_a?(ContentItem::TitleAndContext)
      title_component_params = {
        title: schema_item("aaib-reports")["title"],
        context_locale: nil,
        average_title_length: "long",

      }

      assert_equal title_component_params, presented_item("aaib-reports").title_and_context
    end

    test "should not present continuation_link" do
      assert_nil presented_item("aaib-reports").continuation_link
    end

    test "should not present will_continue_on" do
      assert_nil presented_item("aaib-reports").will_continue_on
    end

    test "should present continuation_link" do
      assert_equal(
        presented_item("business-finance-support-scheme").continuation_link,
        "http://www.bigissueinvest.com",
      )
    end

    test "should present will_continue_on" do
      assert_equal(
        presented_item("business-finance-support-scheme").will_continue_on,
        "on the Big Issue Invest website",
      )
    end

    test "removes first published dates for bulk published documents" do
      example = schema_item("aaib-reports")
      example["details"]["metadata"]["bulk_published"] = true

      assert_not present_example(example).metadata[:first_published]

      example["details"]["metadata"]["bulk_published"] = false
      assert present_example(example).metadata[:first_published]

      example["details"]["metadata"] = {}
      assert present_example(example).metadata[:first_published]
    end
  end

  class PresentedSpecialistDocumentWithFinderFacets < SpecialistDocumentTestCase
    def example_with_finder_facets(facets = [], values = {})
      example = schema_item("aaib-reports")
      example_finder = {
        "class" => "govuk-link",
        "base_path" => "/finder-base-path",
        "title" => "Finder title",
        "details" => {
          "document_noun" => "case",
          "filter" => {
            "document_type" => "cma_case",
          },
          "format_name" => "Competition and Markets Authority case",
          "facets" => facets,
        },
      }

      example["details"]["metadata"] = values
      example["links"]["finder"] = [example_finder]
      example
    end

    def example_facet(overrides = {})
      {
        "name" => "Facet name",
        "key" => "facet-key",
        "type" => "text",
        "filterable" => false,
      }.merge(overrides)
    end

    test "includes non-filterable facet as text in metadata" do
      values = { "facet-key" => "document-value" }
      example = example_with_finder_facets([example_facet], values)

      presented = present_example(example)
      assert_equal "document-value", presented.important_metadata["Facet name"]
    end

    test "includes friendly label for facet value in metadata" do
      overrides = {
        "allowed_values" => [
          {
            "label" => "Document value from label",
            "value" => "document-value",
          },
        ],
      }

      values = { "facet-key" => "document-value" }
      example = example_with_finder_facets([example_facet(overrides)], values)

      presented = present_example(example)
      assert_equal "Document value from label", presented.important_metadata["Facet name"]
    end

    test "falls back to provided value if value not found in allowed list" do
      overrides = {
        "allowed_values" => [
          {
            "label" => "Document value from label",
            "value" => "document-value",
          },
        ],
      }

      values = { "facet-key" => "not-an-allowed-value" }
      example = example_with_finder_facets([example_facet(overrides)], values)

      GovukError.expects(:notify).once.with(
        "Facet value not in list of allowed values",
        extra: { error_message: "Facet value 'not-an-allowed-value' not an allowed value for facet 'Facet name' on /aaib-reports/aaib-investigation-to-rotorsport-uk-calidus-g-pcpc content item" },
      )

      presented = present_example(example)
      assert_equal "not-an-allowed-value", presented.important_metadata["Facet name"]
    end

    test "ignores facets in metadata if not a valid finder facet" do
      values = { "random-invalid-facet" => "something-odd" }
      example = example_with_finder_facets([example_facet], values)

      presented = present_example(example)
      assert_empty presented.metadata[:other]
    end

    test "ignores facets if valid key but set to an empty string" do
      example = example_with_finder_facets(
        [
          {
            "name" => "Facet name",
            "key" => "facet-key",
            "type" => "text",
          },
          {
            "name" => "Date facet",
            "key" => "date-facet",
            "type" => "date",
          },
        ],
        "facet-key" => "",
        "date-facet" => "",
      )

      assert_empty present_example(example).metadata[:other]
    end

    test "passes array of multiple values to metadata" do
      overrides = {
        "allowed_values" => [
          {
            "label" => "One",
            "value" => "one",
          },
          {
            "label" => "Two",
            "value" => "two",
          },
        ],
      }

      values = { "facet-key" => %w[one two] }
      example = example_with_finder_facets([example_facet(overrides)], values)

      presented = present_example(example)
      assert_equal %w[One Two], presented.important_metadata["Facet name"]
    end

    test "creates links for filterable friendly values" do
      overrides = {
        "filterable" => true,
        "allowed_values" => [
          {
            "label" => "Something",
            "value" => "something",
          },
        ],
      }

      values = { "facet-key" => "something" }
      example = example_with_finder_facets([example_facet(overrides)], values)

      presented = present_example(example)
      expected_link = "<a class=\"govuk-link app-link\" href=\"/finder-base-path?facet-key%5B%5D=something\">Something</a>"
      assert_equal expected_link, presented.important_metadata["Facet name"]
    end

    test "includes friendly dates for date facets in metadata" do
      overrides = { "type" => "date" }
      values = { "facet-key" => "2010-01-01" }
      example = example_with_finder_facets([example_facet(overrides)], values)

      presented_metadata = present_example(example).important_metadata
      assert_equal "1 January 2010", presented_metadata["Facet name"]
    end

    test "puts date facets together and before text facets" do
      example = example_with_finder_facets(
        [
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
          },
        ],
        "facet-key" => "Text",
        "first-date-facet" => "2010-01-01",
        "second-date-facet" => "2010-02-03",
        "more-text" => "More text",
      )

      expected_order = ["First date facet", "Second date facet", "Facet name", "More text"]
      assert_equal expected_order, present_example(example).important_metadata.keys
    end

    test "sends an error notification when there is no finder" do
      example = schema_item("aaib-reports")
      example["links"]["finder"] = []

      GovukError.expects(:notify).with(
        "Finder not found",
        extra: { error_message: "Finder not found in /aaib-reports/aaib-investigation-to-rotorsport-uk-calidus-g-pcpc content item" },
      )

      present_example(example).important_metadata
    end

    test "omits first_published_at facet values from `other` section of component parameters to avoid duplicates" do
      facets = [
        {
          "name" => "Published",
          "key" => "first_published_at",
          "type" => "date",
        },
      ]
      example = example_with_finder_facets(facets, "first_published_at" => "2010-01-01")

      presented = present_example(example)
      assert_not presented.metadata[:other]["Published"]
    end

    test "uses first published date in facets as canonical publish date if provided" do
      facets = [
        {
          "name" => "Published",
          "key" => "first_published_at",
          "type" => "date",
        },
      ]
      example = example_with_finder_facets(facets, "first_published_at" => "2010-01-01")

      example["details"]["change_history"] = [
        {
          "note" => "A date in the change history",
          "public_timestamp" => "2002-02-02",
        },
      ]

      presented = present_example(example)
      assert Time.zone.parse(presented.published) == Time.zone.parse("2010-01-01")
    end
  end
end
