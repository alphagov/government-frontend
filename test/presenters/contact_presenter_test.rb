require 'presenter_test_helper'

class ContactPresenterTest
  class PresentedContact < PresenterTestCase
    def format_name
      "contact"
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end

    test 'presents the title' do
      assert_equal schema_item['title'], presented_item.title
    end

    test 'only presents related item sections when section has items' do
      schema = schema_item('contact_with_email_and_no_other_contacts')
      presented = presented_item('contact_with_email_and_no_other_contacts')

      refute schema['links']['related']
      assert_empty presented.related_items[:sections].select { |section| section[:title] == 'Other contacts' }
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
  end
end
