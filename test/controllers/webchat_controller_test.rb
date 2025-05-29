require "test_helper"

class WebchatControllerTest < ActionController::TestCase
  test "user can visit the webchat URL and see complete webchat interface" do
    @request.path = "/government/organisations/hm-passport-office/contact/hm-passport-office-webchat"
    get :show

    assert_response :success
    assert_not_nil assigns(:webchat_config)
    assert_equal "https://d1y02qp19gjy8q.cloudfront.net", assigns(:webchat_config).csp_connect_src

    assert_select ".webchat-container"
    assert_select ".js-webchat" do
      assert_select "[data-availability-url='https://d1y02qp19gjy8q.cloudfront.net/availability/18555309']"
      assert_select "[data-open-url='https://d1y02qp19gjy8q.cloudfront.net/open/index.html']"
      assert_select "[data-redirect='false']"
    end

    assert_select ".js-webchat-advisers-error"
    assert_select ".js-webchat-advisers-unavailable"
    assert_select ".js-webchat-advisers-busy"
    assert_select ".js-webchat-advisers-available"

    assert_select ".js-webchat-open-button[data-module='ga4-link-tracker']" do |elements|
      ga4_data = JSON.parse(elements.first["data-ga4-link"])
      assert_equal "navigation", ga4_data["event_name"]
      assert_equal "webchat", ga4_data["type"]
      assert_equal "Speak to an adviser now", ga4_data["text"]
    end
  end

  test "returns 404 when configuration is not found" do
    Webchat.stubs(:find).raises(ActiveModel::ValidationError, "Config not found")

    get :show
    assert_response :not_found
    assert_includes @response.body, "Webchat configuration not found"
  end

  test "renders Welsh text when locale is 'cy'" do
    I18n.locale = :cy
    get :show
    assert_includes @response.body, "Siaradwch â chynghorydd nawr"

    doc = Nokogiri::HTML(@response.body)
    link = doc.css(".js-webchat-open-button").first
    ga4_data = JSON.parse(link["data-ga4-link"])
    assert_equal "Speak to an adviser now", ga4_data["text"]
  ensure
    I18n.locale = :en
  end
end
