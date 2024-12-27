require "test_helper"

class ContentItemOrganisationBrandingTest < ActiveSupport::TestCase
  include ContentItem::OrganisationBranding

  def tested_organisation
    {
      "base_path" => "/base-path",
      "details" => {
        "brand" => "department-of-health",
        "logo" => {
          "formatted_title" => "Department<br/>of Health",
          "crest" => "single-identity",
        },
      },
    }
  end

  test "presents the logo for organisations" do
    logo = organisation_logo(tested_organisation)

    assert_equal logo[:organisation][:brand], tested_organisation["details"]["brand"]
    assert_equal logo[:organisation][:url], tested_organisation["base_path"]
    assert_equal logo[:organisation][:crest], tested_organisation["details"]["logo"]["crest"]
    assert_equal logo[:organisation][:name], tested_organisation["details"]["logo"]["formatted_title"]
  end

  test "presents the brand colour class for organisations" do
    assert_equal "department-of-health-brand-colour", organisation_brand_class(tested_organisation)
  end

  test "alters the brand for organisations with an executive order crest" do
    organisation = tested_organisation
    organisation["details"]["logo"]["crest"] = "eo"

    assert_not_equal organisation_brand(organisation), tested_organisation["details"]["brand"]
    assert_equal organisation_brand(organisation), "executive-office"
  end

  test "no branding when organisation is not set" do
    organisation = nil

    assert_nil organisation_brand(organisation)
    assert_nil executive_order_crest?(organisation)
  end

  test "includes an image organisations with a custom logo" do
    organisation = tested_organisation
    organisation["details"]["logo"]["image"] = {
      "url" => "url",
      "alt_text" => "alt_text",
    }

    logo = organisation_logo(organisation)

    assert_equal logo[:organisation][:image][:url], organisation["details"]["logo"]["image"]["url"]
    assert_equal logo[:organisation][:image][:alt_text], organisation["details"]["logo"]["image"]["alt_text"]
  end
end
