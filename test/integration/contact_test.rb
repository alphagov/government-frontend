require 'test_helper'

class ContactTest < ActionDispatch::IntegrationTest
  test "online forms are rendered" do
    setup_and_visit_content_item('contact')
    within_component_govspeak do |component_args|
      content = component_args.fetch("content")

      assert content.include? @content_item["details"]["more_info_contact_form"]
      first_contact_form_link = @content_item["details"]["contact_form_links"].first

      assert content.include? first_contact_form_link['description']

      html = Nokogiri::HTML.parse(content)
      assert_not_nil html.at_css("h2#online-forms")
      assert_not_nil html.at_css("a[href='#{first_contact_form_link['link']}']")
    end
  end

  test "phones are rendered" do
    setup_and_visit_content_item('contact')
    within_component_govspeak do |component_args|
      content = component_args.fetch("content")
      first_phone = @content_item["details"]["phone_numbers"].first["number"]

      html = Nokogiri::HTML.parse(content)
      assert_not_nil html.at_css("h2#phone-title")
      assert_not_nil html.at("p:contains(\"#{first_phone}\")")
      assert_not_nil html.at("p:contains(\"24 hours a day, 7 days a week\")")
    end
  end
end
