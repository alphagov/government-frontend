require 'test_helper'

class ContactTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "online forms are rendered" do
    setup_and_visit_content_item('contact')

    assert page.has_text?("If HMRC needs to contact you about anything confidential they’ll reply by phone or post.")
    assert page.has_text?("Contact HMRC to report suspicious activity in relation to smuggling, customs, excise and VAT fraud.")

    assert page.has_css?("h2#online-forms-title")
    first_contact_form_link = @content_item["details"]["contact_form_links"].first
    assert page.has_css?("a[href='#{first_contact_form_link['link']}']")
  end

  test "emails are rendered" do
    setup_and_visit_content_item('contact')

    assert page.has_css?("h2#email-title")
    assert page.has_css?(".email:first-of-type")
  end

  test "phones are rendered" do
    setup_and_visit_content_item('contact')

    first_phone = @content_item["details"]["phone_numbers"].first

    assert page.has_css?("h2#phone-title")
    assert page.has_css?("h3", text: first_phone['title'])
    assert page.has_css?("p", text: first_phone['number'])
    assert page.has_css?("p", text: "24 hours a day, 7 days a week")
  end

  test "phone number heading is not rendered when only one number" do
    setup_and_visit_content_item('contact_with_welsh')

    assert_equal 1, @content_item["details"]["phone_numbers"].size
    first_phone = @content_item["details"]["phone_numbers"].first
    refute page.has_css?("h3", text: first_phone['title'])
  end

  test "posts are rendered" do
    setup_and_visit_content_item('contact')

    assert page.has_css?("h2#post-title")
    assert page.has_css?(".street-address")
  end
end
