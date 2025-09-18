require "test_helper"

class AssetManagerRedirectTest < ActionDispatch::IntegrationTest
  test "should redirect to asset path for '/government/uploads/*path'" do
    get "/government/uploads/system/uploads/attachment_data/file/1234567/example.pdf"
    assert_redirected_to "http://assets.test.gov.uk/government/uploads/system/uploads/attachment_data/file/1234567/example.pdf"
  end
end
