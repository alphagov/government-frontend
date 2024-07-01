RSpec.describe("Step Navigation", type: :request) do
  %w[guide answer publication].each do |schema_name|
    it "#{schema_name} shows step by step navigation where relevant" do
      content_item = content_store_has_schema_example(schema_name, "#{schema_name}-with-step-navs")
      content_item["base_path"] = "/pass-plus"
      stub_content_store_has_item(content_item["base_path"], content_item)
      allow_any_instance_of(ContentItemsController).to receive(:page_in_scope?).and_return(false)
      get content_item["base_path"]

      expect(response.status).to eq(200)
      expect(response.body).to include("Learn to drive a car: step by step")
    end

    it "#{schema_name} does not show step by step navigation where relevant" do
      content_item = content_store_has_schema_example(schema_name, schema_name)
      content_item["base_path"] = "/not-part-of-a-step-by-step"
      stub_content_store_has_item(content_item["base_path"], content_item)
      allow_any_instance_of(ContentItemsController).to receive(:page_in_scope?).and_return(false)

      get content_item["base_path"]

      expect(response.status).to eq(200)
      expect(response.body).not_to include("Learn to drive a car: step by step")
    end
  end
end
