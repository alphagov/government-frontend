# WARNING: This test won't catch if the actual layouts change in static. It's
# only testing whether we're correctly telling slimmer to process the search
# elements, and slimmer is trying to process the layouts in the way we expect.
RSpec.describe("Service Manual", type: :system) do
  let!(:content_item) { content_store_has_schema_example("service_manual_guide", "service_manual_guide") }
  let!(:path) { "/#{path_for(content_item)}" }

  before do
    html = File.read(Rails.root.join("spec/support/slimmer_templates/wrapper.html"))
    allow_any_instance_of(Slimmer::Skin).to receive(:load_template).and_return(html)
  end

  it "has a search form scoped to the manual" do
    content_item = content_store_has_schema_example("service_manual_guide", "service_manual_guide")
    visit "/#{path_for(content_item)}"

    expect(page).to have_css("#global-header #search")
    expect(page).to have_css("form#search input[type=hidden][name=filter_manual][value='/service-manual']", visible: false)
  end

  it "does not show a search box for the manual homepage" do
    content_item = content_store_has_schema_example("service_manual_homepage", "service_manual_homepage")
    visit "/#{path_for(content_item)}"

    expect(page).not_to have_css("#global-header #search")
  end
end
