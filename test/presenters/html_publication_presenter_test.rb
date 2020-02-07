require "presenter_test_helper"

class HtmlPublicationPresenterTest < PresenterTestCase
  def schema_name
    "html_publication"
  end

  test "presents the basic details of a content item" do
    assert_equal schema_item("published")["schema_name"], presented_item("published").schema_name
    assert_equal schema_item("published")["links"]["parent"][0]["document_type"], presented_item("published").format_sub_type
    assert_equal schema_item("published")["title"], presented_item("published").title
    assert_equal schema_item("published")["details"]["body"], presented_item("published").body
  end

  test "presents a list of contents extracted from headings in the body" do
    expected_contents_list_item = { text: "Details of the application", id: "details-of-the-application", href: "#details-of-the-application" }
    assert_equal expected_contents_list_item, presented_item("published").contents[0]
  end

  test "presents the meta data info of a content item" do
    assert_equal schema_item("print_with_meta_data")["details"]["isbn"], presented_item("print_with_meta_data").isbn
  end

  test "presents the last change date" do
    published = presented_item("published")
    assert_equal "Published 17 January 2016", published.last_changed

    updated = presented_item("updated")
    assert_equal "Updated 2 February 2016", updated.last_changed
  end

  test "presents the list of organisations" do
    multiple_organisations_html_publication = schema_item("multiple_organisations")
    organisation_titles = multiple_organisations_html_publication["links"]["organisations"].map { |o| o["title"] }

    presented_unordered_html_publication = HtmlPublicationPresenter.new(multiple_organisations_html_publication)
    presented_organisations = presented_unordered_html_publication.organisations.map { |o| o["title"] }

    assert_equal organisation_titles, presented_organisations
  end

  test "has organisation branding" do
    assert presented_item("published").is_a?(ContentItem::OrganisationBranding)
  end

  test "includes custom organisation logos when a single organisation is listed" do
    presented = presented_item("updated")
    organisation = presented.organisations.first
    example_logo = schema_item("updated")["links"]["organisations"][0]["details"]["logo"]["image"].symbolize_keys
    presented_logo = presented.organisation_logo(organisation)[:organisation][:image]

    assert presented.organisations.count == 1
    assert_equal example_logo, presented_logo
  end

  test "hides custom organisation logos when multiple organisations listed together" do
    presented = presented_item("multiple_organisations")
    organisation = presented.organisations.first
    organisation["details"]["logo"]["image"] = {
      "url" => "url",
    }

    assert presented.organisations.count > 1
    assert_not presented.organisation_logo(organisation)[:organisation][:image]
  end
end
