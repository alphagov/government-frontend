require 'test_helper'

class DocumentCollectionTest < ActionDispatch::IntegrationTest
  test "document collection" do
    setup_and_visit_content_item('document_collection')
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
  end

  test "renders metadata and document footer" do
    setup_and_visit_content_item('document_collection')
    assert_has_component_metadata_pair("first_published", "29 February 2016")

    from = ["<a href=\"/government/organisations/driver-and-vehicle-standards-agency\">Driver and Vehicle Standards Agency</a>"]
    assert_has_component_metadata_pair("from", from)
    assert_has_component_document_footer_pair("from", from)
  end

  test "renders body when provided" do
    setup_and_visit_content_item('document_collection_with_body')
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "renders contents with link to each collection group" do
    setup_and_visit_content_item('document_collection')
    @content_item["details"]["collection_groups"].each do |group|
      assert page.has_css?('nav a', text: group["title"])
    end
  end

  test "renders each collection group" do
    setup_and_visit_content_item('document_collection')
    groups = @content_item["details"]["collection_groups"]
    group_count = groups.count

    groups.each do |group|
      assert page.has_css?('.group-title', text: group["title"])
    end

    within ".sidebar-with-body" do
      assert page.has_css?(shared_component_selector("govspeak"), count: group_count)
      assert page.has_css?('.group-document-list', count: group_count)
    end
  end

  test "renders all collection documents" do
    setup_and_visit_content_item('document_collection')
    documents = @content_item["links"]["documents"]

    documents.each do |doc|
      assert page.has_css?('.group-document-list-item-title a', text: doc["title"])
    end

    assert page.has_css?('.group-document-list .group-document-list-item', count: documents.count)

    within ".group-document-list:first-of-type .group-document-list-item:first-of-type .group-document-list-item-attributes" do
      assert page.has_text?('16 March 2007'), "has properly formatted date"
      assert page.has_css?('[datetime="2007-03-16T15:00:02+00:00"]'), "has iso8601 datetime attribute"
      assert page.has_text?('Guidance'), "has formatted document_type"
    end
  end

  test "withdrawn collection" do
    setup_and_visit_content_item('document_collection_withdrawn')
    assert page.has_css?('title', text: "[Withdrawn]", visible: false)

    within ".withdrawal-notice" do
      assert page.has_text?('This collection was withdrawn'), "is withdrawn"
      assert_has_component_govspeak(@content_item["withdrawn_notice"]["explanation"])
      assert page.has_css?("time[datetime='#{@content_item['withdrawn_notice']['withdrawn_at']}']")
    end
  end

  test "historically political collection" do
    setup_and_visit_content_item('document_collection_political')

    within ".history-notice" do
      assert page.has_text?('This collection was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government')
    end
  end
end
