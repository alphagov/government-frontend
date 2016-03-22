require 'test_helper'

class HtmlPublicationPresenterTest < ActiveSupport::TestCase
  test 'presents the basic details of a content item' do
    assert_equal html_publication['format'], presented_html_publication.format
    assert_equal html_publication['links']['parent'][0]['format_sub_type'], presented_html_publication.format_sub_type
    assert_equal html_publication['title'], presented_html_publication.title
    assert_equal html_publication['details']['body'], presented_html_publication.body
  end

  test 'presents the last change date' do
    published = presented_html_publication("published")
    assert_equal "Published 17 January 2016", published.last_changed

    updated = presented_html_publication("updated")
    assert_equal "Updated 2 February 2016", updated.last_changed
  end

  test 'presents the path to its parent' do
    assert_equal html_publication["links"]["parent"][0]["base_path"], presented_html_publication.parent_base_path
  end

  test 'presents the list of organisations' do
    multiple_organisations_html_publication = govuk_content_schema_example('html_publication', 'multiple_organisations')
    organisation_titles = multiple_organisations_html_publication["links"]["organisations"].map { |o| o["title"] }

    presented_unordered_html_publication = HtmlPublicationPresenter.new(multiple_organisations_html_publication)
    presented_organisations = presented_unordered_html_publication.organisations.map { |o| o["title"] }

    assert_equal organisation_titles, presented_organisations
  end

  test "presents the branding for organisations" do
    mo_presented_html_publication = presented_html_publication("multiple_organisations")
    mo_presented_html_publication.organisations.each do |organisation|
      assert_equal mo_presented_html_publication.organisation_brand(organisation), organisation["brand"]
    end
  end

  test "alters the branding for executive office organisations" do
    organisation = {
      "brand" => "cabinet-office",
      "logo" => {
        "formatted_title" => "Prime Minister's Office, 10 Downing Street",
        "crest" => "eo"
      }
    }
    assert_equal presented_html_publication("prime_ministers_office").organisation_brand(organisation), "executive-office"
  end

  def presented_html_publication(type = 'published')
    content_item = html_publication(type)
    HtmlPublicationPresenter.new(content_item)
  end

  def html_publication(type = 'published')
    govuk_content_schema_example('html_publication', type)
  end
end
