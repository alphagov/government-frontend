require 'presenter_test_helper'

class GuidePresenterTest
  class PresentedGuide < PresenterTestCase
    def schema_name
      "guide"
    end

    test 'has parts' do
      assert presented_item.is_a?(ContentItem::Parts)
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

    test 'presents withdrawn in the title for withdrawn content' do
      presented_item = presented_item(schema_name, nil, "withdrawn_notice" => { "explanation": "Withdrawn", "withdrawn_at": "2014-08-22T10:29:02+01:00" })
      assert_equal "[Withdrawn] The national curriculum", presented_item.page_title
    end

    test "presents a print link" do
      assert_equal "#{schema_item['base_path']}/print", presented_item.print_link
    end

    test "presents only next navigation when first part" do
      parts = schema_item['details']['parts']
      nav = presented_item.previous_and_next_navigation
      expected_nav = {
        next_page: {
          url: "#{schema_item['base_path']}/#{parts[1]['slug']}",
          title: "Next",
          label: parts[1]['title']
        }
      }

      assert_equal nav, expected_nav
    end

    test "presents previous and next navigation" do
      parts = schema_item['details']['parts']
      nav = presented_item('guide', parts[1]['slug']).previous_and_next_navigation
      expected_nav = {
        next_page: {
          url: "#{schema_item['base_path']}/#{parts[2]['slug']}",
          title: "Next",
          label: parts[2]['title']
        },
        previous_page: {
          url: schema_item['base_path'],
          title: "Previous",
          label: parts[0]['title']
        }
      }

      assert_equal nav, expected_nav
    end

    test "presents only previous navigation when last part" do
      parts = schema_item['details']['parts']
      nav = presented_item('guide', parts.last['slug']).previous_and_next_navigation
      expected_nav = {
        previous_page: {
          url: "#{schema_item['base_path']}/#{parts[-2]['slug']}",
          title: "Previous",
          label: parts[-2]['title']
        }
      }

      assert_equal nav, expected_nav
    end

    test "presents no navigation when no other parts" do
      nav = presented_item('single-page-guide').previous_and_next_navigation
      assert_equal nav, {}
    end

    test "sends an error notification for guide with no parts" do
      GovukError.expects(:notify).with(
        'Guide with no parts',
        extra: { error_message: 'Guide rendered without any parts at /correct-marriage-registration' }
      )

      presented_item('no-part-guide').has_parts?
    end

    test "presents access tokens in part links when provided" do
      presented = presented_item('guide')
      presented.draft_access_token = 'some_token'
      expected_param = '?token=some_token'

      presented.parts.each do |part|
        assert part['full_path'].ends_with?(expected_param)
      end

      presented.parts_navigation.flatten.each_with_index do |link, i|
        if i.positive?
          assert expected_param.in?(link)
        end
      end

      nav = presented.previous_and_next_navigation
      assert nav[:next_page][:url].ends_with?(expected_param)
    end

  private

    def presented_item(type = schema_name, part_slug = nil, overrides = {})
      schema_example_content_item = schema_item(type)
      part_slug = "/#{part_slug}" if part_slug

      GuidePresenter.new(
        schema_example_content_item.merge(overrides),
        "#{schema_example_content_item['base_path']}#{part_slug}"
      )
    end
  end
end
