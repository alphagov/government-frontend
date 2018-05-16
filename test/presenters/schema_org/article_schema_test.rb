require 'test_helper'

class SchemaOrgArticleSchemaTest < ActiveSupport::TestCase
  test 'the basics' do
    schema = schema_for_content("base_path" => "/foo")

    assert_equal schema["@type"], "Article"
    assert_equal schema["mainEntityOfPage"]["@id"], "https://www.test.gov.uk/foo"
  end

  test 'the primary publishing org as author' do
    schema = schema_for_content(
      "links" => {
        "primary_publishing_organisation" => [
          {
            "content_id" => "d944229b-a5ad-453d-8e16-cb5dcfcdb866",
            "title" => "Foo",
            "locale" => "en",
            "base_path" => "/foo",
          }
        ]
      }
    )

    assert_equal({ "@type" => "Organization", "name" => "Foo", "url" => "https://www.test.gov.uk/foo" }, schema["author"])
  end

  test 'an image' do
    schema = schema_for_content(
      "details" => {
        "image" => {
          "url" => "/foo",
        },
        # Needed to make the content valid according to schema
        "body" => "Foo yo",
        "first_public_at" => Time.now.iso8601,
      }
    )

    assert_equal(["/foo"], schema["image"])
  end

  def schema_for_content(content)
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: 'case_study') do |random|
      random.merge(content)
    end
    presenter = CaseStudyPresenter.new(content_item)

    SchemaOrg::ArticleSchema.new(presenter).structured_data
  end
end
