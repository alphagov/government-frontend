require "active_model/validations"

RSpec.describe(Webchat, type: :model) do
  it "creates an instance" do
    webchat_config = { "base_path" => "/government/contact/my-amazing-service", "open_url" => "https://www.tax.service.gov.uk/csp-partials/open/1023", "availability_url" => "https://www.tax.service.gov.uk/csp-partials/availability/1023", "csp_connect_src" => "https://www.tax.service.gov.uk" }
    instance = Webchat.new(webchat_config)

    expect(webchat_config["base_path"]).to eq(instance.base_path)
    expect(webchat_config["open_url"]).to eq(instance.open_url)
    expect(webchat_config["availability_url"]).to eq(instance.availability_url)
    expect(webchat_config["csp_connect_src"]).to eq(instance.csp_connect_src)
  end

  it "returns an error if config is invalid" do
    webchat_invalid_config = { "base_path" => "/government/contact/my-amazing-service", "availability_url" => "https://www.tax.service.gov.uk/csp-partials/availability/1023" }

    expect { Webchat.new(webchat_invalid_config) }.to raise_error(ActiveModel::ValidationError)
  end
end
