require 'presenter_test_helper'

class HtmlPublicationPresenterTest < PresenterTestCase
  def format_name
    "html_publication"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item("published")['schema_name'], presented_item("published").format
    assert_equal schema_item("published")['links']['parent'][0]['document_type'], presented_item("published").format_sub_type
    assert_equal schema_item("published")['title'], presented_item("published").title
    assert_equal schema_item("published")['details']['body'], presented_item("published").body
    assert_equal schema_item("published")['details']['headings'], presented_item("published").contents
  end

  test 'presents no contents when headings is an empty list' do
    assert_equal schema_item("prime_ministers_office")['details']['headings'], '<ol></ol>'
    refute presented_item("prime_ministers_office").contents?
  end

  test 'presents the last change date' do
    published = presented_item("published")
    assert_equal "Published 17 January 2016", published.last_changed

    updated = presented_item("updated")
    assert_equal "Updated 2 February 2016", updated.last_changed
  end

  test 'presents the list of organisations' do
    multiple_organisations_html_publication = schema_item('multiple_organisations')
    organisation_titles = multiple_organisations_html_publication["links"]["organisations"].map { |o| o["title"] }

    presented_unordered_html_publication = HtmlPublicationPresenter.new(multiple_organisations_html_publication)
    presented_organisations = presented_unordered_html_publication.organisations.map { |o| o["title"] }

    assert_equal organisation_titles, presented_organisations
  end

  test "presents the logo for organisations" do
    mo_presented_item = presented_item("multiple_organisations")
    mo_presented_item.organisations.each do |organisation|
      logo = mo_presented_item.organisation_logo(organisation)
      assert_equal logo[:organisation][:brand], organisation["details"]["brand"]
    end
  end

  test "alters the logo for executive office organisations" do
    organisation = {
      "details" => {
        "brand" => "cabinet-office",
        "logo" => {
          "formatted_title" => "Prime Minister's Office, 10 Downing Street",
          "crest" => "eo"
        }
      }
    }

    logo = presented_item("prime_ministers_office").organisation_logo(organisation)

    assert_equal logo[:organisation][:brand], "executive-office"
  end
end
