RSpec.describe(GoneHelper, type: :view) do
  include GoneHelper

  it "renders a link to the full url" do
    request = double(protocol: "http://", host: "www.dev.gov.uk")
    expected_html = link_to("http://www.dev.gov.uk/government/example", "/government/example", class: "govuk-link")

    expect(alternative_path_link(request, "/government/example")).to eq(expected_html)
  end
end
