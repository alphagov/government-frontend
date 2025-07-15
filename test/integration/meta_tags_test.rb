require "test_helper"

class MetaTagsTest < ActionDispatch::IntegrationTest
  test "correct meta tags are displayed for pages" do
    publication = GovukSchemas::RandomExample.for_schema(frontend_schema: "publication") do |random|
      random.merge(
        "title" => "Zhe title",
        "withdrawn_notice" => {},
      )
    end

    stub_content_store_has_item("/some-page", publication.to_json)

    visit_with_cachebust "/some-page"

    assert page.has_css?("meta[property='og:title'][content='Zhe title']", visible: false)
  end

  test "correct meta tags are displayed for pages without images" do
    publication = GovukSchemas::RandomExample.for_schema(frontend_schema: "publication")

    stub_content_store_has_item("/some-page", publication.to_json)

    visit_with_cachebust "/some-page"

    assert page.has_css?("meta[name='twitter:card'][content='summary']", visible: false)
  end
end
