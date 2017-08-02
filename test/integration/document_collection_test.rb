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

  test 'includes tracking data on all collection documents' do
    setup_and_visit_content_item('document_collection')
    groups = page.all('.group-document-list')

    groups.each do |group|
      assert_equal(
        "track-click",
        group['data-module'],
        "Expected the module 'track-click' to be set in the group #{group.inspect}"
      )
    end

    first_section_links = groups.first.all('.group-document-list-item-title a')
    first_link = first_section_links.first

    assert_equal(
      'navDocumentCollectionLinkClicked',
      first_link['data-track-category'],
      'Expected a tracking category to be set in the data attributes'
    )

    assert_equal(
      '1.1',
      first_link['data-track-action'],
      'Expected the link position to be set in the data attributes'
    )

    assert_match(
      first_link['data-track-label'],
      first_link[:href],
      'Expected the content item base path to be set in the data attributes'
    )

    assert first_link['data-track-options'].present?

    data_options = JSON.parse(first_link['data-track-options'])

    assert_equal(
      first_section_links.count.to_s,
      data_options['dimension28'],
      'Expected the total number of content items within the section to be present in the tracking options'
    )

    assert_equal(
      first_link.text,
      data_options['dimension29'],
      'Expected the subtopic title to be present in the tracking options'
    )
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

    within ".app-c-banner" do
      assert page.has_text?('This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government')
    end
  end
end
