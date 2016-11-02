require 'presenter_test_helper'

class DocumentCollectionPresenterTest < PresenterTestCase
  def format_name
    "document_collection"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item['description'], presented_item.description
    assert_equal schema_item['format'], presented_item.format
    assert_equal schema_item['title'], presented_item.title
    assert_equal schema_item('document_collection_with_body')['details']['body'], presented_item('document_collection_with_body').body
  end

  test 'presents a contents list based on collection groups' do
    contents = [
      "<a href=\"#car-and-light-van\">Car and light van</a>",
      "<a href=\"#moped-and-motorcycle\">Moped and motorcycle</a>",
      "<a href=\"#lorry\">Lorry</a>",
      "<a href=\"#bus-and-coach\">Bus and coach</a>",
      "<a href=\"#driver-and-rider-trainer\">Driver and rider trainer</a>",
      "<a href=\"#developed-driving-competence\">Developed driving competence</a>"
    ]

    assert_equal contents, presented_item.contents
  end

  test 'presents a group heading with generated ID' do
    heading = '<h3 class="group-title" id="heading-with-spaces">Heading with Spaces</h3>'
    assert_equal heading, presented_item.group_heading("title" => "Heading with Spaces")
  end

  test 'presents an ordered list of group documents' do
    documents = [
      {
        public_updated_at: Time.parse("2007-03-16 15:00:02 +0000"),
        document_type: "guidance",
        title: "National standard for driving cars and light vans",
        base_path: "/government/publications/national-standard-for-driving-cars-and-light-vans"
      }
    ]
    document_ids = schema_item["details"]["collection_groups"].first["documents"]
    assert_equal documents, presented_item.group_document_links("documents" => [document_ids.first])
  end
end

class DocumentCollectionWithGroupContainingMissingDocumentLinkPresenterTest < PresenterTestCase
  def format_name
    "document_collection"
  end

  test "does not present the withdrawn document" do
    presenter = presented_item("document_collection_with_single_missing_document")

    group_with_missing_document = presenter
      .groups
      .select { |g| g["title"] == "One document missing from links" }
      .first

    presented_links = presenter.group_document_links(group_with_missing_document)
    presented_links_base_paths = presented_links.collect { |link| link[:base_path] }

    assert_equal(
      ["/government/publications/national-standard-for-developed-driving-competence"],
      presented_links_base_paths
    )
  end
end

class DocumentCollectionWithGroupContainingNoDocumentsPresenterTest < PresenterTestCase
  def format_name
    "document_collection"
  end

  test "does not present a group which contains no documents" do
    presenter = presented_item("document_collection_with_no_documents")

    group_with_missing_documents = presenter
      .groups
      .select { |g| g["title"] == "No documents" }

    assert_empty group_with_missing_documents
  end
end

class DocumentCollectionWithGroupContainingOnlyMissingDocumentLinksPresenterTest < PresenterTestCase
  def format_name
    "document_collection"
  end

  test "does not present the group" do
    presenter = presented_item(
      "document_collection_with_missing_links_documents"
    )

    group_with_missing_documents = presenter
      .groups
      .select { |g| g["title"] == "All documents missing from links" }

    assert_empty group_with_missing_documents
  end
end
