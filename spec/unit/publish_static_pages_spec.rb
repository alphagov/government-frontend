RSpec.describe("Publish Static Pages", type: :model) do
  it "sends static pages to publishing api" do
    expect_publishing(PublishStaticPages::PAGES)
    PublishStaticPages.publish_all
  end

  it "presents pages that are valid according to the relevant schema" do
    PublishStaticPages::PAGES.each do |page|
      presented = PublishStaticPages.present_for_publishing_api(page)

      expect_valid_for_schema(presented[:content])
    end
  end

  def expect_publishing(pages)
    pages.each do |page|
      expect(Services.publishing_api).to receive(:put_path).with(page[:base_path], publishing_app: "government-frontend", override_existing: true)
      expect(Services.publishing_api).to receive(:put_content).with(page[:content_id], hash_including(document_type: "history", schema_name: "history", base_path: page[:base_path], title: page[:title], update_type: "minor"))
      expect(Services.publishing_api).to receive(:publish).with(page[:content_id], nil, locale: "en")
    end
  end

  def expect_valid_for_schema(presented_page)
    schema = GovukSchemas::Schema.find(publisher_schema: presented_page[:schema_name])
    errors = JSON::Validator.fully_validate(schema, presented_page)

    expect(errors).to be_empty
  end
end
