require "test_helper"

class ServiceManualSearchRedirectTest < ActionDispatch::IntegrationTest
  test "the legacy search URL redirects to /search and retains parameters" do
    get "/service-manual/search?q=bananas"
    assert_redirected_to "/search?filter_manual=%2Fservice-manual&q=bananas"
  end
end
