RSpec.describe(AssetManagerRedirectController, type: :request) do
  it "sets the cache-control max-age to 1 day" do
    host! "some-host.com"
    get "/government/uploads/asset.txt"

    expect(response.headers["Cache-Control"]).to eq("max-age=86400, public")
  end

  it "redirects asset requests from 'government/upload' path to the assets hostname" do
    get "/government/uploads/asset.txt"

    expect(response).to redirect_to("http://assets.test.gov.uk/government/uploads/asset.txt")
  end

  it "redirects asset requests from '/media' path to the assets hostname" do
    get "/media/filename/asset.txt"

    expect(response).to redirect_to("http://assets.test.gov.uk/media/filename/asset.txt")
  end

  context "using the draft stack" do
    around do |ex|
      ClimateControl.modify(PLEK_HOSTNAME_PREFIX: "draft-") do
        ex.run
      end
    end

    it "redirects to assets hostname for legacy path" do
      get "/government/uploads/asset.txt"

      expect(response).to redirect_to("http://draft-assets.test.gov.uk/government/uploads/asset.txt")
    end

    it "redirects to assets hostname for modern path" do
      get "/media/filename/asset.txt"

      expect(response).to redirect_to("http://draft-assets.test.gov.uk/media/filename/asset.txt")
    end
  end
end
