require "test_helper"
require "gds_api/test_helpers/account_api"

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::AccountApi
  include GdsApi::TestHelpers::ContentStore
  include GovukPersonalisation::TestHelpers::Requests

  SAVE_A_PAGE_CSS_SELECTOR = ".app-c-save-this-page".freeze

  test "does not show the save-page button when the feature flag is off" do
    stub_feature_flag_off
    set_up_and_visit_content_item("detailed_guide", "detailed_guide")

    assert_not has_save_this_page_button_css_selector
  end

  test "logged out - shows the add_page_button when the feature flag is on" do
    stub_feature_flag_on
    set_up_and_visit_content_item("detailed_guide", "detailed_guide")

    assert has_save_page_button("/guidance/salary-sacrifice-and-the-effects-on-paye")
  end

  test "invalid session - shows the add_page_button when the feature flag is on" do
    stub_feature_flag_on
    stub_account_api_unauthorized_get_saved_page(page_path: "/guidance/salary-sacrifice-and-the-effects-on-paye")
    set_up_and_visit_content_item("detailed_guide", "detailed_guide")

    assert has_save_page_button("/guidance/salary-sacrifice-and-the-effects-on-paye")
  end

  test "logged in - shows the add_page_button when the feature flag is on and page is not saved" do
    stub_feature_flag_on
    mock_logged_in_session
    stub_account_api_does_not_have_saved_page(page_path: "/guidance/salary-sacrifice-and-the-effects-on-paye")
    set_up_and_visit_content_item("detailed_guide", "detailed_guide")

    assert has_save_page_button("/guidance/salary-sacrifice-and-the-effects-on-paye")
  end

  test "logged in - shows the remove_page_button when the feature flag is on and page is saved" do
    stub_feature_flag_on
    mock_logged_in_session
    stub_account_api_get_saved_page(page_path: "/guidance/salary-sacrifice-and-the-effects-on-paye")
    set_up_and_visit_content_item("detailed_guide", "detailed_guide")

    assert has_remove_this_page_button("/guidance/salary-sacrifice-and-the-effects-on-paye")
  end

private

  def stub_feature_flag_on
    @controller.stubs(:save_this_page_enabled?).returns(true)
  end

  def stub_feature_flag_off
    @controller.stubs(:save_this_page_enabled?).returns(false)
  end

  def set_up_and_visit_content_item(document_type, example_name)
    content_item = content_store_has_schema_example(document_type, example_name)
    stub_content_store_has_item(content_item["base_path"], content_item)
    path = content_item["base_path"][1..]

    get :show, params: { path: path }
  end

  def has_save_this_page_button_css_selector
    response.body.include?(SAVE_A_PAGE_CSS_SELECTOR)
  end

  def has_save_page_button(page_path = "/test")
    response.body.include?(I18n.t("components.save_this_page.add_page_button")) &&
      response.body.include?("#{Plek.new.website_root}/account/saved-pages/add?page_path=#{page_path}")
  end

  def has_remove_this_page_button(page_path = "/test")
    response.body.include?(I18n.t("components.save_this_page.remove_page_button")) &&
      response.body.include?("#{Plek.new.website_root}/account/saved-pages/remove?page_path=#{page_path}")
  end
end
