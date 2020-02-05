require "test_helper"
require "active_model"

class WebchatTest < ActiveSupport::TestCase
  webchat_config = {
    "base_path" => "/government/contact/my-amazing-service",
    "open_url" => "https://www.tax.service.gov.uk/csp-partials/open/1023",
    "availability_url" => "https://www.tax.service.gov.uk/csp-partials/availability/1023",
  }

  test "should create instance correctly" do
    instance = Webchat.new(webchat_config)

    assert_equal(instance.base_path, webchat_config["base_path"])
    assert_equal(instance.open_url, webchat_config["open_url"])
    assert_equal(instance.availability_url, webchat_config["availability_url"])
  end

  test "should return error if config is invalid" do
    webchat_invalid_config = {
      "base_path" => "/government/contact/my-amazing-service",
      "availability_url" => "https://www.tax.service.gov.uk/csp-partials/availability/1023",
    }

    assert_raises ActiveModel::ValidationError do
      Webchat.new(webchat_invalid_config)
    end
  end
end
