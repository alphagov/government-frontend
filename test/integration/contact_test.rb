require 'test_helper'

class ContactTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "online forms are rendered" do
    setup_and_visit_content_item('contact')
    within_component_govspeak do |component_args|
      content = component_args.fetch("content")

      assert content.include? @content_item["details"]["more_info_contact_form"]
      first_contact_form_link = @content_item["details"]["contact_form_links"].first

      assert content.include? first_contact_form_link['description']

      html = Nokogiri::HTML.parse(content)
      assert_not_nil html.at_css("h2#online-forms-title")
      assert_not_nil html.at_css("a[href='#{first_contact_form_link['link']}']")
    end
  end

  test "emails are rendered" do
    setup_and_visit_content_item('contact')
    within_component_govspeak do |component_args|
      content = component_args.fetch("content")

      html = Nokogiri::HTML.parse(content)
      assert_not_nil html.at_css("h2#email-title")
      assert_not_nil html.at_css(".email:first-of-type")
    end
  end

  test "phones are rendered" do
    setup_and_visit_content_item('contact')
    within_component_govspeak do |component_args|
      first_phone = @content_item["details"]["phone_numbers"].first
      html = Nokogiri::HTML.parse(component_args.fetch("content"))

      assert_not_nil html.at_css("h2#phone-title")
      assert_not_nil html.at("h3:contains(\"#{first_phone['title']}\")")
      assert_not_nil html.at("p:contains(\"#{first_phone['number']}\")")
      assert_not_nil html.at("p:contains(\"24 hours a day, 7 days a week\")")
    end
  end

  test "phone number heading is not rendered when only one number" do
    setup_and_visit_content_item('contact_with_welsh')
    within_component_govspeak do |component_args|
      first_phone = @content_item["details"]["phone_numbers"].first
      html = Nokogiri::HTML.parse(component_args.fetch("content"))

      assert_equal 1, @content_item["details"]["phone_numbers"].size
      refute html.at("h3:contains(\"#{first_phone['title']}\")")
    end
  end

  test "posts are rendered" do
    setup_and_visit_content_item('contact')
    within_component_govspeak do |component_args|
      content = component_args.fetch("content")
      html = Nokogiri::HTML.parse(content)

      assert_not_nil html.at_css("h2#post-title")
      assert_not_nil html.at_css(".street-address")
    end
  end
end
