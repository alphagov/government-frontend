require "test_helper"

class DocumentCollectionTest < ActionDispatch::IntegrationTest
  test "document collection with no body" do
    setup_and_visit_content_item("document_collection")
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
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

  test "adds a contents list, with one list item per document collection group, if the group contains documents" do
    setup_and_visit_content_item("document_collection")
    assert_equal 6, @content_item["details"]["collection_groups"].size

    @content_item["details"]["collection_groups"].each do |group|
      assert page.has_css?("nav a", text: group["title"])
    end
  end

  test "ignores document collection groups that have no documents when presenting the contents list" do
    setup_and_visit_content_item("document_collection")
    @content_item["details"]["collection_groups"] << { "title" => "Empty Group", "documents" => [] }
    assert_equal 7, @content_item["details"]["collection_groups"].size

    content_list_items = all("nav.gem-c-contents-list .gem-c-contents-list__list-item")
    assert_equal 6, content_list_items.size

    @content_item["details"]["collection_groups"].each do |group|
      next if group["documents"].empty?

      assert page.has_css?("nav a", text: group["title"])
    end

    assert page.has_css?(".gem-c-contents-list", text: "Contents")
  end

  test "renders no contents list if body has no h2s and is long and collection groups are empty" do
    content_item = get_content_example("document_collection")

    content_item["details"]["body"] = <<~HTML
      <div class="empty group">
        <p>#{Faker::Lorem.characters(number: 200)}</p>
        <p>#{Faker::Lorem.characters(number: 200)}</p>
        <p>#{Faker::Lorem.characters(number: 200)}</p>
      </div>
    HTML

    content_item["details"]["collection_groups"] = [
      {
        "body" => "<div class=\"empty group\">\n</div>",
        "documents" => [],
        "title" => "Empty Group",
      },
    ]

    content_item["base_path"] += "-no-h2s"

    stub_content_store_has_item(content_item["base_path"], content_item.to_json)
    visit(content_item["base_path"])
    assert_not page.has_css?(".gem-c-contents-list")
  end

  test "renders contents list if body has h2s and collection groups are empty" do
    content_item = get_content_example("document_collection")

    content_item["details"]["body"] = <<~HTML
      <div class="empty group">
        <h2 id="one">One</h2>
        <p>#{Faker::Lorem.characters(number: 200)}</p>
        <h2 id="two">Two</h2>
        <p>#{Faker::Lorem.characters(number: 200)}</p>
        <h2 id="three">Three</h2>
        <p>#{Faker::Lorem.characters(number: 200)}</p>
      </div>
    HTML

    content_item["details"]["collection_groups"] = [
      {
        "body" => "<div class=\"empty group\">\n</div>",
        "documents" => [],
        "title" => "Empty Group",
      },
    ]

    content_item["base_path"] += "-h2s"

    stub_content_store_has_item(content_item["base_path"], content_item.to_json)
    visit(content_item["base_path"])
    assert page.has_css?(".gem-c-contents-list")
  end

  test "renders each collection group" do
    setup_and_visit_content_item("document_collection")
    groups = @content_item["details"]["collection_groups"]
    group_count = groups.count

    groups.each do |group|
      assert page.has_css?(".govuk-heading-m.govuk-\\!-font-size-27", text: group["title"])
    end

    within ".gem-c-contents-list-with-body" do
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
end
