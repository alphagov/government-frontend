require 'test_helper'

class AnswerTest < ActionDispatch::IntegrationTest
  include RummagerHelpers

  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "renders title and body" do
    setup_and_visit_content_item('answer')
    assert page.has_text?(@content_item["title"])
    assert page.has_text?("Bydd angen cod cychwyn arnoch i ddechrau defnyddio’r holl wasanaethau hyn, ac eithrio TAW. Anfonir hwn atoch cyn pen saith diwrnod gwaith ar ôl i chi gofrestru. Os ydych chi’n byw dramor, gall gymryd hyd at 21 diwrnod i gyrraedd.")
  end

  test "related links are rendered" do
    setup_and_visit_content_item('answer')

    first_related_link = @content_item["details"]["external_related_links"].first

    within(".gem-c-related-navigation") do
      assert page.has_css?('.gem-c-related-navigation__section-link--other[href="' + first_related_link["url"] + '"]', text: first_related_link["title"])
    end
  end

  test "highlight boxes are shown if there are taxon links" do
    flunk
    example_with_links = govuk_content_schema_example('answer')
    stub_most_popular_content(example_with_links, 2, "guidance_and_regulation")
    setup_and_visit_content_item('guide')
    assert page.has_css?('.gem-c-highlight-boxes__title[href$="/apply-apprenticeship"]')
  end
end
