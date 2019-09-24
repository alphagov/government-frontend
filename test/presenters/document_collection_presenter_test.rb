require "presenter_test_helper"

class DocumentCollectionPresenterTest
  class TestCase < PresenterTestCase
    def schema_name
      "document_collection"
    end
  end

  class PresentedDocumentCollection < TestCase
    test "presents the title" do
      assert_equal schema_item["title"], presented_item.title
    end

    test "presents the description" do
      assert_equal schema_item["description"], presented_item.description
    end

    test "presents the schema name" do
      assert_equal schema_item["schema_name"], presented_item.schema_name
    end

    test "presents the body" do
      example = "document_collection_with_body"
      expected_body = schema_item(example)["details"]["body"]
      presented_body = presented_item(example).body

      assert_equal expected_body, presented_body
    end

    test "presents a contents list based on collection groups" do
      contents = [
        { text: "Car and light van", id: "car-and-light-van", href: "#car-and-light-van" },
        { text: "Moped and motorcycle", id: "moped-and-motorcycle", href: "#moped-and-motorcycle" },
        { text: "Lorry", id: "lorry", href: "#lorry" },
        { text: "Bus and coach", id: "bus-and-coach", href: "#bus-and-coach" },
        { text: "Driver and rider trainer", id: "driver-and-rider-trainer", href: "#driver-and-rider-trainer" },
        { text: "Developed driving competence", id: "developed-driving-competence", href: "#developed-driving-competence" },
      ]

      assert_equal contents, presented_item.contents
    end

    test "presents a group heading with generated ID" do
      heading = '<h3 class="group-title" id="heading-with-spaces">Heading with Spaces</h3>'

      assert_equal heading, presented_item.group_heading("title" => "Heading with Spaces")
    end

    test "presents an ordered list of group documents" do
      documents = [
        {
          link: {
            text: "National standard for driving cars and light vans",
            path: "/government/publications/national-standard-for-driving-cars-and-light-vans",
            data_attributes: {
              track_category: "navDocumentCollectionLinkClicked",
              track_action: "1.1",
              track_label: "/government/publications/national-standard-for-driving-cars-and-light-vans",
              track_options: {
                dimension28: "1",
                dimension29: "National standard for driving cars and light vans"
              }
            }
          },
          metadata: {
            public_updated_at: Time.zone.parse("2007-03-16 15:00:02 +0000"),
            document_type: "Guidance"
          }
        }
      ]
      document_ids = schema_item["details"]["collection_groups"].first["documents"]

      assert_equal documents, presented_item.group_document_links({ "documents" => [document_ids.first] }, 0)
    end

    test "it handles the document type lacking a translation" do
      schema_data = schema_item

      document = schema_data["links"]["documents"].first.tap do |link|
        link["document_type"] = "non-existant"
      end

      grouped = present_example(schema_data).group_document_links(
        { "documents" => [document["content_id"]] },
        0,
      )

      assert_nil grouped.first[:metadata][:document_type]
    end

    test "it handles public_updated_at not being specified" do
      schema_data = schema_item

      document = schema_data["links"]["documents"].first.tap do |link|
        link.delete("public_updated_at")
      end

      grouped = present_example(schema_data).group_document_links(
        { "documents" => [document["content_id"]] },
        0,
      )

      assert_nil grouped.first[:metadata][:public_updated_at]
    end
  end

  class GroupWithMissingDocument < TestCase
    test "does not present the withdrawn document" do
      presenter = presented_item("document_collection_with_single_missing_document")

      group_with_missing_document =
        presenter
          .groups
          .select { |g| g["title"] == "One document missing from links" }
          .first

      presented_links = presenter.group_document_links(group_with_missing_document, 0)
      presented_links_base_paths = presented_links.collect { |link| link[:link][:path] }

      assert_equal(
        ["/government/publications/national-standard-for-developed-driving-competence"],
        presented_links_base_paths
      )
    end
  end

  class GroupWithNoDocuments < TestCase
    test "does not present a group which contains no documents" do
      presenter = presented_item("document_collection_with_no_documents")

      group_with_missing_documents =
        presenter
          .groups
          .select { |g| g["title"] == "No documents" }

      assert_empty group_with_missing_documents
    end
  end

  class GroupWithOnlyMissingDocuments < TestCase
    test "does not present the group" do
      presenter = presented_item(
        "document_collection_with_missing_links_documents"
      )

      group_with_missing_documents =
        presenter
          .groups
          .select { |g| g["title"] == "All documents missing from links" }

      assert_empty group_with_missing_documents
    end
  end

  class GroupWithDocumentsWhenThereIsNoLinksDocuments < TestCase
    test "does not present the group" do
      presenter = presented_item(
        "document_collection_with_group_but_no_documents"
      )

      group_with_missing_documents =
        presenter
          .groups
          .select { |g| g["title"] == "Missing documents" }

      assert_empty group_with_missing_documents
    end
  end

  class GroupWithDocumentsWhenThereAreWithdrawnDocuments < TestCase
    test "does not present withdrawn documents" do
      presenter = presented_item(
        "document_collection_with_withdrawn_links_documents"
      )

      presented_documents = presenter.groups.first["documents"]

      expected_number_of_presented_documents = 2

      assert_equal(
        presented_documents.size,
        expected_number_of_presented_documents
      )
    end
  end
end
