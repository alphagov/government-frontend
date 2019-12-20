require "test_helper"

class DocumentCollectionTest < ActionDispatch::IntegrationTest
  test "document collection with no body" do
    setup_and_visit_content_item("document_collection")
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_css?(".gem-c-contents-list")
  end

  test "document collection with no body and 2 collection groups where 1st group has long body" do
    content_item = get_content_example("document_collection")
    content_item["details"]["collection_groups"][0]["body"] = Faker::Lorem.characters(number: 416)
    content_store_has_item(content_item["base_path"], content_item.to_json)
    visit(content_item["base_path"])

    assert page.has_css?(".gem-c-contents-list")
  end

  test "renders metadata and document footer" do
    setup_and_visit_content_item("document_collection")
    assert_has_publisher_metadata(
      published: "Published 29 February 2016",
      metadata:
      {
        "From:":
          {
            "Driver and Vehicle Standards Agency": "/government/organisations/driver-and-vehicle-standards-agency",
          },
      },
    )
    assert_footer_has_published_dates("Published 29 February 2016")
  end

  test "renders body when provided" do
    setup_and_visit_content_item("document_collection_with_body")
    assert page.has_text?("Each regime page provides a current list of asset freeze targets designated by the United Nations (UN), European Union and United Kingdom, under legislation relating to current financial sanctions regimes.")
  end

  test "renders contents with link to each collection group" do
    setup_and_visit_content_item("document_collection")
    @content_item["details"]["collection_groups"].each do |group|
      assert page.has_css?("nav a", text: group["title"])
    end
  end

  test "renders without contents list if it has fewer than 3 items" do
    item = get_content_example("document_collection")
    item["details"]["collection_groups"] = [
      {
        "title" => "Item one",
        "body" => "<p>Content about item one</p>",
        "documents" => %w[a-content-id],
      },
    ]
    content_store_has_item(item["base_path"], item.to_json)
    visit_with_cachebust(item["base_path"])

    assert_not page.has_css?(".gem-c-contents-list")
  end

  test "renders each collection group" do
    setup_and_visit_content_item("document_collection")
    groups = @content_item["details"]["collection_groups"]
    group_count = groups.count

    groups.each do |group|
      assert page.has_css?(".group-title", text: group["title"])
    end

    within ".app-c-contents-list-with-body" do
      assert page.has_css?(".gem-c-govspeak", count: group_count)
      assert page.has_css?(".gem-c-document-list__item-metadata", count: group_count)
    end
  end

  test "renders all collection documents" do
    setup_and_visit_content_item("document_collection")
    documents = @content_item["links"]["documents"]

    documents.each do |doc|
      assert page.has_css?(".gem-c-document-list__item-title", text: doc["title"])
    end

    assert page.has_css?(".gem-c-document-list__item-title", count: documents.count)

    document_lists = page.all(".gem-c-document-list")

    within document_lists[0] do
      list_items = page.all(".gem-c-document-list__item")
      within list_items[0] do
        assert page.has_text?("16 March 2007"), "has properly formatted date"
        assert page.has_css?('[datetime="2007-03-16T15:00:02+00:00"]'), "has iso8601 datetime attribute"
        assert page.has_text?("Guidance"), "has formatted document_type"
      end
    end
  end

  test "includes tracking data on all collection documents" do
    setup_and_visit_content_item("document_collection")
    groups = page.all(".gem-c-document-list")
    assert page.has_css?('[data-module="track-click"]'), count: groups.length

    first_section_links = groups.first.all(".gem-c-document-list__item-title")
    first_link = first_section_links.first

    assert_equal(
      "navDocumentCollectionLinkClicked",
      first_link["data-track-category"],
      "Expected a tracking category to be set in the data attributes",
    )

    assert_equal(
      "1.1",
      first_link["data-track-action"],
      "Expected the link position to be set in the data attributes",
    )

    assert_match(
      first_link["data-track-label"],
      first_link[:href],
      "Expected the content item base path to be set in the data attributes",
    )
    assert first_link["data-track-options"].present?

    data_options = JSON.parse(first_link["data-track-options"])

    assert_equal(
      first_section_links.count.to_s,
      data_options["dimension28"],
      "Expected the total number of content items within the section to be present in the tracking options",
    )

    assert_equal(
      first_link.text,
      data_options["dimension29"],
      "Expected the subtopic title to be present in the tracking options",
    )
  end

  test "withdrawn collection" do
    setup_and_visit_content_item("document_collection_withdrawn")
    assert page.has_css?("title", text: "[Withdrawn]", visible: false)

    within ".gem-c-notice" do
      assert page.has_text?("This collection was withdrawn"), "is withdrawn"
      assert page.has_text?("This information is now out of date.")
      assert page.has_css?("time[datetime='#{@content_item['withdrawn_notice']['withdrawn_at']}']")
    end
  end

  test "historically political collection" do
    setup_and_visit_content_item("document_collection_political")

    within ".app-c-banner" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end
end
