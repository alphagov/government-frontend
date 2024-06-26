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
    stub_content_store_has_item(content_item["base_path"], content_item.to_json)
    visit(content_item["base_path"])

    assert page.has_css?(".gem-c-contents-list")
  end

  test "renders metadata and document footer" do
    setup_and_visit_content_item("document_collection")

    assert_has_metadata({
      published: "29 February 2016",
      from: {
        "Driver and Vehicle Standards Agency": "/government/organisations/driver-and-vehicle-standards-agency",
      },
    })
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
    stub_content_store_has_item(item["base_path"], item.to_json)
    visit_with_cachebust(item["base_path"])

    assert_not page.has_css?(".gem-c-contents-list")
  end

  test "renders each collection group" do
    setup_and_visit_content_item("document_collection")
    groups = @content_item["details"]["collection_groups"]
    group_count = groups.count

    groups.each do |group|
      assert page.has_css?(".govuk-heading-m.govuk-\\!-font-size-27", text: group["title"])
    end

    within ".app-c-contents-list-with-body" do
      assert page.has_css?(".gem-c-govspeak", count: group_count)
      assert page.has_css?(".gem-c-document-list", count: group_count)
    end
  end

  test "renders all collection documents" do
    setup_and_visit_content_item("document_collection")
    documents = @content_item["links"]["documents"]

    documents.each do |doc|
      assert page.has_css?(".gem-c-document-list__item-title", text: doc["title"])
    end

    assert page.has_css?(".gem-c-document-list .gem-c-document-list__item", count: documents.count)

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

    within ".govuk-notification-banner__content" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end

  test "renders with the single page notification button" do
    setup_and_visit_content_item("document_collection")
    assert page.has_css?(".gem-c-single-page-notification-button")
    assert_not page.has_css?(".gem-c-signup-link")
  end

  test "renders with the taxonomy subscription button" do
    setup_and_visit_content_item_with_taxonomy_topic_email_override("document_collection")
    assert page.has_css?(".gem-c-signup-link")
    assert page.has_link?(href: "/email-signup/confirm?topic=/testpath")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
