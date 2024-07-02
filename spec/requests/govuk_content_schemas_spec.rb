RSpec.describe("GOV.UK Content Schemas", type: :request) do
  all_examples_for_supported_schemas.each_with_index do |content_item, index|
    it "can successfully render #{content_item['document_type']} #{index} example" do
      stub_content_store_has_item(content_item["base_path"], content_item)
      stub_parent_breadcrumbs(content_item, content_item["document_type"])
      get "/#{content_item['base_path']}"

      expect(response.status).to eq(200)
    end
  end
end
