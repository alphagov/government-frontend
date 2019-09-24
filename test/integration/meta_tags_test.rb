require "test_helper"

class MetaTagsTest < ActionDispatch::IntegrationTest
  test "correct meta tags are displayed for pages" do
    case_study = GovukSchemas::RandomExample.for_schema(frontend_schema: "news_article") do |random|
      random.merge(
        "title" => "Zhe title",
        "withdrawn_notice" => {},
      )
    end

    content_store_has_item("/some-page", case_study.to_json)

    visit_with_cachebust "/some-page"

    assert page.has_css?("meta[property='og:title'][content='Zhe title']", visible: false)
  end

  test "correct meta tags are displayed for pages without images" do
    case_study = GovukSchemas::RandomExample.for_schema(frontend_schema: "news_article") do |random|
      random["details"].delete("image")
      random
    end

    content_store_has_item("/some-page", case_study.to_json)

    visit_with_cachebust "/some-page"

    assert page.has_css?("meta[name='twitter:card'][content='summary']", visible: false)
  end

  test "correct meta tags are displayed for pages with images" do
    case_study = GovukSchemas::RandomExample.for_schema(frontend_schema: "news_article") do |random|
      random["details"] = random["details"].merge(
        "image" => {
          "url" => "https://example.org/image.jpg",
          "alt_text" => "An accessible alt text",
        }
      )

      random
    end

    content_store_has_item("/some-page", case_study.to_json)

    visit_with_cachebust "/some-page"

    assert page.has_css?("meta[name='twitter:card'][content='summary_large_image']", visible: false)
    assert page.has_css?("meta[name='twitter:image'][content='https://example.org/image.jpg']", visible: false)
    assert page.has_css?("meta[property='og:image'][content='https://example.org/image.jpg']", visible: false)
  end
end
