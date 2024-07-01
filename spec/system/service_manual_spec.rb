RSpec.describe("Service Manual", type: :system) do
  let!(:content_item) { content_store_has_schema_example("service_manual_guide", "service_manual_guide") }
  let!(:path) { "/#{path_for(content_item)}" }

  it "has a search form scoped to the manual" do
    visit path

    expect(page).to have_css("input")
  end

  # it "tells slimmer to scope search results to the manual for a service manual guide" do
  #   content_item = content_store_has_schema_example("service_manual_guide", "service_manual_guide")

  #   expect(Slimmer::Processors::SearchParameterInserter).to receive(:new).with(hash_including: {
  #     Slimmer::Headers::SEARCH_PARAMETERS_HEADER => { filter_manual: "/service-manual" }.to_json,
  #   })
  #   get "/#{path_for(content_item)}"

  #   # byebug
  #   # expect(response.body).to have_css("input")
  #   # assert_select("input[type='hidden'][name='filter_manual'][values='/service-manual']")
  #   # expect(response.headers[Slimmer::Headers::SEARCH_PARAMETERS_HEADER]).to eq({ filter_manual: "/service-manual" }.to_json)
  # end

  # it("tells slimmer not to include a search box in the header for the service manual homepage") do
  #   content_item = content_store_has_schema_example("service_manual_homepage", "service_manual_homepage")
  #   get "/#{path_for(content_item)}"

  #   expect(response.headers[Slimmer::Headers::REMOVE_SEARCH_HEADER]).to be true
  # end
end
