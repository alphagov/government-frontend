require "test_helper"

class WorkingGroupTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    assert_nothing_raised { setup_and_visit_random_content_item }
  end

  test "working groups" do
    setup_and_visit_content_item("long")
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_text?("Contact details")
    assert page.has_text?(@content_item["details"]["email"])

    assert_has_contents_list([
      { text: "Membership",         id: "membership" },
      { text: "Terms of Reference", id: "terms-of-reference" },
      { text: "Meeting Minutes",    id: "meeting-minutes" },
      { text: "Contact details",    id: "contact-details" },
    ])

    assert page.has_text?("Benefits and Credits Consultation Group meeting 28 May 2014")
    assert page.has_css?("h2#contact-details")
  end

  test "with_policies" do
    setup_and_visit_content_item("with_policies")

    policy = @content_item["links"]["policies"][0]
    assert page.has_text?("Policies")
    assert page.has_text?(policy["title"])

    assert page.has_css?("h2#policies")
  end

  test "with a body that has no h2s" do
    item = get_content_example("short")
    item["details"]["body"] = "<div class='govspeak'><p>Some content<p></div>"
    stub_content_store_has_item(item["base_path"], item.to_json)
    visit(item["base_path"])

    assert page.has_text?("Some content")
  end

  test "renders a content list" do
    setup_and_visit_content_item("with_policies")
    assert page.has_css?(".gem-c-contents-list", text: "Contents")
  end

  test "does not render with the single page notification button" do
    setup_and_visit_content_item("long")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
