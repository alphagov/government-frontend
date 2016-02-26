require 'test_helper'

class WorkingGroupTest < ActionDispatch::IntegrationTest
  test "working groups" do
    setup_and_visit_content_item('long')
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_text?("Contact details")
    assert page.has_text?(@content_item["details"]["email"])
    assert_has_component_govspeak(@content_item["details"]["body"])

    assert_has_contents_list([
      { text: "Membership",         id: "membership" },
      { text: "Terms of Reference", id: "terms-of-reference" },
      { text: "Meeting Minutes",    id: "meeting-minutes" },
      { text: "Contact details",    id: "contact-details" },
    ])
    within_component_govspeak(index: 2) do |component_args|
      html = Nokogiri::HTML.parse(component_args.fetch("content"))
      assert_not_nil html.at_css("h2#contact-details")
    end
  end

  test "with_policies" do
    setup_and_visit_content_item('with_policies')

    policy = @content_item["links"]["policies"][0]
    assert page.has_text?("Policies")
    assert page.has_text?(policy["title"])

    # Should render the in-page navigation to Policies with a destination that exists
    assert_has_contents_list([
      { text: "Policies", id: "policies" },
    ])
    within_component_govspeak(index: 2) do |component_args|
      html = Nokogiri::HTML.parse(component_args.fetch("content"))
      assert_not_nil html.at_css("h2#policies")
    end
  end
end
