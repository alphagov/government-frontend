require 'presenter_test_helper'

class ContactPresenterTest
  class PresentedContact < PresenterTestCase
    def format_name
      "contact"
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end

    test 'presents the quick links in related items' do
      first_quick_link = schema_item['details']['quick_links'].first
      first_presented_quick_link = presented_item.related_items.first[:items].first

      assert_equal first_quick_link['title'], first_presented_quick_link[:title]
      assert_equal 'Elsewhere on GOV.UK', presented_item.related_items.first[:title]
    end

    test 'presents the related contacts links in related items' do
      first_related_contact_link = schema_item['links']['related'].first
      first_presented_contact_link = presented_item.related_items.last[:items].first

      assert_equal first_related_contact_link['title'], first_presented_contact_link[:title]
      assert_equal 'Other contacts', presented_item.related_items.last[:title]
    end
  end
end
