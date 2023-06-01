require "presenter_test_helper"

class WorldwideOrganisationPresenterTest < PresenterTestCase
  def schema_name
    "worldwide_organisation"
  end

  test "#title returns the title" do
    assert_equal schema_item["title"], presented_item.title
  end

  test "#body returns the body" do
    assert_equal schema_item["details"]["body"], presented_item.body
  end

  test "#social_media_links returns the social media accounts" do
    assert_equal schema_item["details"]["social_media_links"], presented_item.social_media_accounts
  end
end
