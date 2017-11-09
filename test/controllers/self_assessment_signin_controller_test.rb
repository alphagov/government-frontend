require 'test_helper'

class SelfAssessmentSigninControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  test "choose_sign_in" do
    content_item = content_store_has_schema_example("guide", "guide")
    content_item["base_path"] = "/log-in-file-self-assessment-tax-return/choose-sign-in"
    content_store_has_item(content_item["base_path"], content_item)

    setup_ab_variant("SelfAssessmentSigninTest", "B")

    get :choose_sign_in, params: { path: path_for(content_item) }
    assert_response 200
    assert_not @response.body.include?("You haven't selected an option")
    assert_template("content_items/signin/choose-sign-in")
  end

  test "choose_sign_in with error" do
    content_item = content_store_has_schema_example("guide", "guide")
    content_item["base_path"] = "/log-in-file-self-assessment-tax-return/choose-sign-in"
    content_store_has_item(content_item["base_path"], content_item)

    setup_ab_variant("SelfAssessmentSigninTest", "B")

    get :choose_sign_in, params: { path: path_for(content_item), error: true }
    assert_response 200
    assert_template("content_items/signin/choose-sign-in")
    assert @response.body.include?("You haven't selected an option")
  end

  test "sign_in_options with sign-in-option param set" do
    post :sign_in_options, params: { "sign-in-option" => "government-gateway" }

    assert_response :redirect
    assert_redirected_to "https://www.tax.service.gov.uk/account"
  end

  test "sign_in_options with no sign-in-option param set" do
    post :sign_in_options

    assert_response :redirect
    assert_redirected_to "#{choose_sign_in_path}?error=true"
  end

  test "lost_account_details" do
    content_item = content_store_has_schema_example("guide", "guide")
    content_item["base_path"] = "/log-in-file-self-assessment-tax-return/lost-account-details"
    content_store_has_item(content_item["base_path"], content_item)

    get :lost_account_details, params: { path: path_for(content_item) }
    assert_response 200
    assert_template("content_items/signin/lost-account-details")
  end

  test "not_registered" do
    content_item = content_store_has_schema_example("guide", "guide")
    content_item["base_path"] = "/log-in-file-self-assessment-tax-return/not-registered"
    content_store_has_item(content_item["base_path"], content_item)

    get :not_registered, params: { path: path_for(content_item) }
    assert_response 200
    assert_template("content_items/signin/not-registered")
  end

  def path_for(content_item, locale = nil)
    base_path = content_item['base_path'].sub(/^\//, '')
    base_path.gsub!(/\.#{locale}$/, '') if locale
    base_path
  end
end
