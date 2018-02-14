require 'test_helper'

class GuideTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "guide header and navigation" do
    setup_and_visit_content_item('guide')

    assert page.has_css?("title", visible: false, text: @content_item['title'])
    assert_has_component_title(@content_item['title'])

    assert page.has_css?('.parts-navigation ol')
    assert page.has_css?('.parts-navigation li', count: @content_item['details']['parts'].size)

    @content_item["details"]["parts"].each_with_index do |part, i|
      if i.zero?
        assert page.has_css?('.parts-navigation li', text: part['title'])
        refute page.has_css?('.parts-navigation li a', text: part['title'])
      else
        assert page.has_css?(".parts-navigation li a[href*=\"#{part['slug']}\"]", text: part['title'])
      end
    end

    assert page.has_css?('h1', text: "1. #{@content_item['details']['parts'].first['title']}")
    assert page.has_css?(shared_component_selector("previous_and_next_navigation"))
    assert page.has_css?('.app-c-print-link a[href$="/print"]')
  end

  test "draft access tokens are appended to part links within navigation" do
    setup_and_visit_content_item('guide', '?token=some_token')

    assert page.has_css?('.parts-navigation a[href$="?token=some_token"]')
  end

  test "does not show part navigation, print link or part title when only one part" do
    setup_and_visit_content_item('single-page-guide')

    refute page.has_css?('h1', text: @content_item['details']['parts'].first['title'])
    refute page.has_css?('.parts-navigation')
    refute page.has_css?('.app-c-print-link')
  end
end
