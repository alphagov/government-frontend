require 'component_test_helper'

class NoticeTest < ComponentTestCase
  def component_name
    "notice"
  end

  test "fails to render when no parameters are given" do
    assert_empty render_component({})
  end
end

# This component renders some content using govspeak, which cannot currently be tested using the approach above.
# To cover this gap, below is an integration test that loads the notice page in the component guide in order to test
# that the remaining aspects of the component are being rendered correctly.

class NoticeGovspeakTest < ActionDispatch::IntegrationTest
  test "renders a notice with only a title and no description" do
    visit '/component-guide/notice/default'

    within '.component-guide-preview' do
      assert page.has_selector?(".app-c-notice__title", text: "Statistics release cancelled")
      assert page.has_no_selector?(".app-c-notice__description")
    end
  end

  test "renders a notice with an aria label" do
    visit '/component-guide/notice/default'
    assert page.has_selector?(".component-guide-preview section[aria-label]")
  end

  test "renders a notice with a title and description text" do
    visit '/component-guide/notice/with_description_text'

    within '.component-guide-preview' do
      assert page.has_selector?(".app-c-notice__title", text: "Statistics release cancelled")
      assert page.has_selector?(".app-c-notice__description", text: "Duplicate, added in error")
    end
  end

  test "renders a notice with a title and description govspeak" do
    visit '/component-guide/notice/with_description_govspeak'

    within '.component-guide-preview' do
      assert page.has_selector?(".app-c-notice__title", text: "Statistics release update")
      assert_has_component_govspeak("<p>The Oil &amp; Gas Authority launched a new website on 3 October 2016 to reflect its new status as a government company.</p><p>This formalises the transfer of the Secretary of State’s regulatory powers in respect of oil and gas to the OGA, and grants it new powers. This website will no longer be updated. Visitors should refer to <a rel=\"external\" href=\"https://www.ogauthority.co.uk/news-publications/announcements/2015/establishment-of-the-oil-and-gas-authority-1/\">www.ogauthority.co.uk</a></p>")
    end
  end
end
