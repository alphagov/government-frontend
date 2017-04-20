require 'presenter_test_helper'

class GuidePresenterTest
  class PresentedGuide < PresenterTestCase
    def format_name
      "guide"
    end

    test "presents unique page titles for each part" do
      assert_equal presented_item.page_title, schema_item['title']
      schema_item['details']['parts'].each do |part|
        assert_equal presented_item('guide', part['slug']).page_title, "#{schema_item['title']}: #{part['title']}"
      end
    end

    test "presents part titles with their index" do
      first_part_title = schema_item['details']['parts'].first['title']
      assert_equal presented_item.current_part_title_with_index, "1. #{first_part_title}"
    end

    test "presents a print link" do
      assert_equal "#{schema_item['base_path']}/print", presented_item.print_link
    end

  private

    def presented_item(type = format_name, part_slug = nil, overrides = {})
      schema_example_content_item = schema_item(type)
      part_slug = "/#{part_slug}" if part_slug

      GuidePresenter.new(
        schema_example_content_item.merge(overrides),
        "#{schema_example_content_item['base_path']}#{part_slug}"
      )
    end
  end
end
