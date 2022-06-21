require "test_helper"

class AssetManagerRedirectControllerTest < ActionController::TestCase
  test "sets the cache-control max-age to 1 day" do
    request.host = "some-host.com"
    get :show, params: { path: "asset.txt" }

    assert_equal @response.headers["Cache-Control"], "max-age=86400, public"
  end

  test "redirects asset requests to the assets hostname" do
    get :show, params: { path: "asset.txt" }

    assert_redirected_to "http://assets.test.gov.uk/government/uploads/asset.txt"
  end

  test "redirects to assets hostname respect the draft stack" do
    ClimateControl.modify PLEK_HOSTNAME_PREFIX: "draft-" do
      get :show, params: { path: "asset.txt" }

      assert_redirected_to "http://draft-assets.test.gov.uk/government/uploads/asset.txt"
    end
  end
end
