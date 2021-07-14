require "test_helper"

class PublishStaticPagesTest < ActiveSupport::TestCase
  test "sends static pages to publishing api" do
    expect_publishing(PublishStaticPages::PAGES)

    PublishStaticPages.publish_all
  end

  test "static pages presented to the publishing api are valid according to the relevant schema" do
    PublishStaticPages::PAGES.each do |page|
      presented = PublishStaticPages.present_for_publishing_api(page)
      expect_valid_for_schema(presented[:content])
    end
  end

  def expect_publishing(pages)
    pages.each do |page|
      Services.publishing_api.expects(:put_path)
        .with(page[:base_path], publishing_app: "government-frontend", override_existing: true)

      if page[:document_type] == "get_involved"
        Services.publishing_api.expects(:put_content)
        .with(
          page[:content_id],
          has_entries(
            document_type: "get_involved",
            schema_name: "get_involved",
            base_path: page[:base_path],
            title: page[:title],
            update_type: "minor",
          ),
        )
      else
        Services.publishing_api.expects(:put_content)
          .with(
            page[:content_id],
            has_entries(
              document_type: "history",
              schema_name: "history",
              base_path: page[:base_path],
              title: page[:title],
              update_type: "minor",
            ),
          )
      end

      Services.publishing_api.expects(:publish)
        .with(page[:content_id], nil, locale: "en")
    end
  end

  def expect_valid_for_schema(presented_page)
    schema = GovukSchemas::Schema.find(publisher_schema: presented_page[:schema_name])
    errors = JSON::Validator.fully_validate(schema, presented_page)
    assert errors.empty?, errors.join("\n")
  end
end
