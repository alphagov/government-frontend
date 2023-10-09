require "test_helper"

class AssetManagerRedirectControllerTest < ActionController::TestCase
  test "sets the cache-control max-age to 1 day" do
    request.host = "some-host.com"
    get :redirect_government_uploads_path, params: { path: "asset.txt" }

    assert_equal @response.headers["Cache-Control"], "max-age=86400, public"
  end

  test "redirects asset requests from 'government/upload' path to the assets hostname" do
    get :redirect_government_uploads_path, params: { path: "asset.txt" }

    assert_redirected_to "http://assets.test.gov.uk/government/uploads/asset.txt"
  end

  test "redirects asset requests from '/media' path to the assets hostname" do
    get :redirect_media_path, params: { path: "filename/asset.txt" }

    assert_redirected_to "http://assets.test.gov.uk/media/filename/asset.txt"
  end

  test "redirects to assets hostname respect the draft stack for legacy path" do
    ClimateControl.modify PLEK_HOSTNAME_PREFIX: "draft-" do
      get :redirect_government_uploads_path, params: { path: "asset.txt" }

      assert_redirected_to "http://draft-assets.test.gov.uk/government/uploads/asset.txt"
    end
  end

  test "redirects to assets hostname respect the draft stack for modern path" do
    ClimateControl.modify PLEK_HOSTNAME_PREFIX: "draft-" do
      get :redirect_media_path, params: { path: "filename/asset.txt" }

      assert_redirected_to "http://draft-assets.test.gov.uk/media/filename/asset.txt"
    end
  end
end
