require "test_helper"

class WorldwideOrganisation::LinkedContactPresenterTest < ActiveSupport::TestCase
  setup do
    content_item = govuk_content_schema_example("worldwide_office", "worldwide_office")

    @contact_content_item = content_item.dig("links", "contact").first
  end

  test "#post_address returns nil when nil on the content item" do
    @contact_content_item["details"]["post_addresses"] = nil

    presented_item = WorldwideOrganisation::LinkedContactPresenter.new(@contact_content_item)

    assert_nil presented_item.post_address
  end

  test "#post_address returns the first post address from the content item as a formatted address" do
    expected_address =
      "<address class=\"govuk-body\"><p class=\"adr\">\n"\
      "<span class=\"fn\">British Embassy Manila</span><br />\n"\
      "<span class=\"street-address\">120 Upper McKinley Road, McKinley Hill</span> <span class=\"region\">Manila</span><br />\n"\
      "<span class=\"postal-code\">1634</span> <span class=\"locality\">Taguig City</span><br />\n"\
      "<span class=\"country-name\">Philippines</span>\n</p>\n</address>"

    presented_item = WorldwideOrganisation::LinkedContactPresenter.new(@contact_content_item)

    assert_equal expected_address, presented_item.post_address
  end

  test "#email returns nil when nil on the content item" do
    @contact_content_item["details"]["email_addresses"] = nil

    presented_item = WorldwideOrganisation::LinkedContactPresenter.new(@contact_content_item)

    assert_nil presented_item.email
  end

  test "#email returns the first email address from the content item" do
    presented_item = WorldwideOrganisation::LinkedContactPresenter.new(@contact_content_item)

    assert_equal "ukinthephilippines@fco.gov.uk", presented_item.email
  end

  test "#contact_form_link returns nil when nil on the content item" do
    @contact_content_item["details"]["contact_form_links"] = nil

    presented_item = WorldwideOrganisation::LinkedContactPresenter.new(@contact_content_item)

    assert_nil presented_item.contact_form_link
  end

  test "#contact_form_link returns the contact form link from the content item" do
    presented_item = WorldwideOrganisation::LinkedContactPresenter.new(@contact_content_item)

    assert_equal "http://www.gov.uk/contact-consulate-manila", presented_item.contact_form_link
  end

  test "#comments returns the contact description" do
    expected_comments =
      "<p class=\"govuk-body\">24/7 consular support is available by telephone for all routine enquiries and emergencies. "\
      "Please call +63 (02) 8 858 2200 / +44 20 7136 6857. <br/><br/>Public access to the embassy is by appointment only. "\
      "Please visit https://www.gov.uk/world/philippines or call +63 (02) 8 858 2200.</p>"

    presented_item = WorldwideOrganisation::LinkedContactPresenter.new(@contact_content_item)

    assert_equal expected_comments, presented_item.comments
  end
end
