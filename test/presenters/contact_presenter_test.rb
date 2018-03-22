require 'presenter_test_helper'

class ContactPresenterTest
  class PresentedContact < PresenterTestCase
    def schema_name
      "contact"
    end

    test 'presents the title' do
      assert_equal schema_item['title'], presented_item.title
    end

    test 'only presents related item sections when section has items' do
      schema = schema_item('contact_with_email_and_no_other_contacts')
      presented = presented_item('contact_with_email_and_no_other_contacts')

      refute schema['links']['related']
      other_contacts_section = presented.related_items[:sections].select { |section| section[:title] == 'Other contacts' }
      assert_empty other_contacts_section
    end

    test 'presents quick links in related items' do
      first_quick_link = schema_item['details']['quick_links'].first
      first_presented_quick_link = presented_item.related_items[:sections].first[:items].first

      assert_equal first_quick_link['title'], first_presented_quick_link[:title]
      assert_equal 'Elsewhere on GOV.UK', presented_item.related_items[:sections].first[:title]
    end

    test 'presents related contacts links in related items' do
      first_related_contact_link = schema_item['links']['related'].first
      first_presented_contact_link = presented_item.related_items[:sections].last[:items].first

      assert_equal first_related_contact_link['title'], first_presented_contact_link[:title]
      assert_equal 'Other contacts', presented_item.related_items[:sections].last[:title]
    end

    test 'presents online form links' do
      assert_equal schema_item['details']['contact_form_links'].first['link'], presented_item.online_form_links.first[:url]
    end

    test 'presents online form body' do
      assert_equal schema_item['details']['more_info_contact_form'], presented_item.online_form_body
    end

    test 'phone returns correctly' do
      phone_number = schema_item['details']['phone_numbers'][0]
      presented_phone_number = presented_item.phone[0]
      assert_equal phone_number["number"], presented_phone_number[:numbers][0][:number]
      assert_equal phone_number["textphone"].blank?, presented_phone_number[:numbers][0][:textphone].nil?
      assert_equal phone_number["title"], presented_phone_number[:title]
      assert_equal phone_number["description"].strip, presented_phone_number[:description]
      assert_equal phone_number["open_hours"].strip, presented_phone_number[:opening_times]
      assert_equal phone_number["best_time_to_call"].strip, presented_phone_number[:best_time_to_call]
    end

    test 'phone_body returns correctly' do
      assert_equal schema_item['details']['more_info_phone_number'], presented_item.phone_body
    end

    test 'post' do
      post_address = schema_item['details']['post_addresses'][0]
      presented_post_address = presented_item.post[0]
      assert_equal post_address['description'].strip, presented_post_address[:description]
      rendered_presented_address = presented_post_address[:v_card].reduce('') { |acc, hash| acc << hash[:value].strip }
      rendered_input_address = %w(title street_address locality region postal_code world_location).reduce('') do |acc, key|
        acc << post_address[key].strip
      end
      assert_equal rendered_input_address, rendered_presented_address
      assert_equal 'fn', presented_post_address[:v_card][0][:v_card_class]
    end

    test 'post_body returns correctly' do
      assert_equal schema_item['details']['more_info_post_address'], presented_item.post_body
    end

    test 'email' do
      assert_equal schema_item['details']['email_addresses'][0]['email'].strip, presented_item.email[0][:email]
      assert_equal schema_item['details']['email_addresses'][0]['title'].strip, presented_item.email[0][:v_card][0][:value]
    end

    test 'email_body' do
      assert_equal schema_item['details']['more_info_email_address'], presented_item.email_body
    end

    test 'handles more info when set to nil' do
      example = schema_item
      example['details']['more_info_phone_number'] = nil
      example['details']['more_info_email_address'] = nil
      example['details']['more_info_post_address'] = nil
      example['details']['more_info_contact_form'] = nil

      assert_nil present_example(example).phone_body
      assert_nil present_example(example).email_body
      assert_nil present_example(example).post_body
      assert_nil present_example(example).online_form_body
    end

    test 'handles more info when not set' do
      example = schema_item
      example['details'].delete('more_info_phone_number')
      example['details'].delete('more_info_email_address')
      example['details'].delete('more_info_post_address')
      example['details'].delete('more_info_contact_form')

      assert_nil present_example(example).phone_body
      assert_nil present_example(example).email_body
      assert_nil present_example(example).post_body
      assert_nil present_example(example).online_form_body
    end

    test 'breadcrumbs' do
      assert_equal [
        {
          title: "Home",
          url: "/"
        },
        {
          title: "HM Revenue & Customs",
          url: "/government/organisations/hm-revenue-customs"
        },
        {
          title: "Contact HM Revenue & Customs",
          url: "/government/organisations/hm-revenue-customs/contact"
        }
      ], presented_item.breadcrumbs
    end

    test 'no breadcrumbs render with no organisations' do
      schema = schema_item('contact')
      schema["links"]["organisations"] = []

      assert_equal [], present_example(schema).breadcrumbs
    end

    test 'no breadcrumbs render with no organisations set' do
      schema = schema_item('contact')
      schema["links"].delete("organisations")
      assert_equal [], present_example(schema).breadcrumbs
    end

    test 'no breadcrumbs render with two organisations' do
      schema = schema_item('contact')
      two_orgs = [
        schema["links"]["organisations"],
        schema["links"]["organisations"]
      ].flatten

      schema["links"]["organisations"] = two_orgs
      assert_equal [], present_example(schema).breadcrumbs
    end

    test 'presents webchat' do
      schema = schema_item('contact_with_webchat')
      presented = present_example(schema)
      assert_equal true, presented.show_webchat?
      assert_equal presented.webchat_availability_url, "https://www.tax.service.gov.uk/csp-partials/availability/1030"
      assert_equal presented.webchat_open_url, "https://www.tax.service.gov.uk/csp-partials/open/1030"
    end
  end
end
