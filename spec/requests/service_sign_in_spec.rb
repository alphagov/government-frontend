RSpec.describe("Service Sign In", type: :request) do
  it "redirects route for root service_sign_in page" do
    content_item = content_store_has_schema_example("service_sign_in", "service_sign_in")
    invalid_part_path = path_for(content_item)
    stub_request(:get, /#{invalid_part_path}/).to_return(status: 200, body: content_item.to_json, headers: {})
    get "/#{invalid_part_path}"

    expect(response).to redirect_to("#{content_item['base_path']}/#{content_item['details']['choose_sign_in']['slug']}")
  end

  it "redirects route for leaf service_sign_in page" do
    content_item = content_store_has_schema_example("service_sign_in", "service_sign_in")
    invalid_part_path = "#{path_for(content_item)}/invalid-slug"
    stub_request(:get, /#{invalid_part_path}/).to_return(status: 200, body: content_item.to_json, headers: {})
    get "/#{invalid_part_path}"

    expect(response).to redirect_to("#{content_item['base_path']}/#{content_item['details']['choose_sign_in']['slug']}")
  end

  it "renders choose_sign_in template for service_sign_in page" do
    content_item = content_store_has_schema_example("service_sign_in", "service_sign_in")
    path = "#{path_for(content_item)}/#{content_item['details']['choose_sign_in']['slug']}"
    stub_request(:get, /#{path}/).to_return(status: 200, body: content_item.to_json, headers: {})
    get "/#{path}"

    expect(response).to render_template(:service_sign_in)
  end

  it "renders create_new_account template for service_sign_in page" do
    content_item = content_store_has_schema_example("service_sign_in", "service_sign_in")
    path = "#{path_for(content_item)}/#{content_item['details']['create_new_account']['slug']}"
    stub_request(:get, /#{path}/).to_return(status: 200, body: content_item.to_json, headers: {})
    get "/#{path}"

    expect(response).to render_template(:service_sign_in)
  end

  it "raises a 404 for a content item which isn't a service_sign_in page" do
    path = "this/is/not/a/sign/in/page"
    post "/#{path}"

    expect(response.status).to eq(404)
  end

  it "service_sign_in_options with option param set" do
    content_item = content_store_has_schema_example("service_sign_in", "service_sign_in")
    path = "#{path_for(content_item)}/#{content_item['details']['choose_sign_in']['slug']}"
    option = content_item["details"]["choose_sign_in"]["options"][0]
    value = option["text"].parameterize
    link = option["url"]
    stub_request(:get, /#{path}/).to_return(status: 200, body: content_item.to_json, headers: {})
    post "/#{path}", params: { option: value }

    expect(response).to redirect_to(link)
  end

  it "service_sign_in_options with no option param set displays choose_sign_in page with error" do
    content_item = content_store_has_schema_example("service_sign_in", "service_sign_in")
    path = "#{path_for(content_item)}/#{content_item['details']['choose_sign_in']['slug']}"
    stub_request(:get, /#{path}/).to_return(status: 200, body: content_item.to_json, headers: {})
    post "/#{path}"

    expect(@controller.instance_variable_get(:@error)).not_to be_nil
    expect(response).to render_template(:service_sign_in)
  end

  it "invalid selected url for service_sign_in page set displays choose_sign_in page with error" do
    content_item = content_store_has_schema_example("service_sign_in", "service_sign_in")
    path = "#{path_for(content_item)}/#{content_item['details']['choose_sign_in']['slug']}"
    stub_request(:get, /#{path}/).to_return(status: 200, body: content_item.to_json, headers: {})
    post "/#{path}", params: { option: nil }

    expect(@controller.instance_variable_get(:@error)).not_to be_nil
    expect(response).to render_template(:service_sign_in)
  end

  it "includes _ga as a query param when redirecting if set" do
    content_item = govuk_content_schema_example("service_sign_in", "service_sign_in")
    link = "https://www.horse.service.gov.uk/account?horse=brown"
    content_item["details"]["choose_sign_in"]["options"][0]["url"] = link
    stub_content_store_has_item(content_item["base_path"], content_item)
    path = "#{path_for(content_item)}/#{content_item['details']['choose_sign_in']['slug']}"
    option = content_item["details"]["choose_sign_in"]["options"][0]
    value = option["text"].parameterize
    stub_request(:get, /#{path}/).to_return(status: 200, body: content_item.to_json, headers: {})
    post "/#{path}", params: { _ga: "1.1111111.1111111.111111111", option: value }

    expect(response).to redirect_to("https://www.horse.service.gov.uk/account?horse=brown&_ga=1.1111111.1111111.111111111")
  end
end
