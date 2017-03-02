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
      content = component_args.fetch("content")
      first_phone = @content_item["details"]["phone_numbers"].first["number"]

      html = Nokogiri::HTML.parse(content)
      assert_not_nil html.at_css("h2#phone-title")
      assert_not_nil html.at("p:contains(\"#{first_phone}\")")
      assert_not_nil html.at("p:contains(\"24 hours a day, 7 days a week\")")
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

  test "related links are rendered" do
    setup_and_visit_content_item('contact')
    within shared_component_selector("related_items") do
      quick_links = @content_item["details"]["quick_links"]
      assert_equal quick_links, JSON.parse(page.text).fetch("sections").first["items"]

      first_related_contacts_links = @content_item["links"]["related"].first
      first_parsed_related_contacts_links = JSON.parse(page.text).fetch("sections").last["items"].first
      assert_equal first_related_contacts_links["title"], first_parsed_related_contacts_links["title"]
      assert_equal first_related_contacts_links["base_path"], first_parsed_related_contacts_links["url"]
    end
  end
end
