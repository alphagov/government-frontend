require 'component_test_helper'

class ShareLinksTest < ComponentTestCase
  def component_name
    "share-links"
  end

  test "renders nothing when no share links provided" do
    assert_empty render_component({})
  end

  test "renders share links correctly" do
    render_component(facebook_href: '/facebook', twitter_href: '/twitter')
    assert_select ".app-c-share-links .app-c-share-links__link[href=\"/facebook\"]"
    assert_select ".app-c-share-links .app-c-share-links__link[href=\"/twitter\"]"
  end

  test "renders a default title if no custom title is provided" do
    render_component(facebook_href: '/facebook', twitter_href: '/twitter')
    assert_select ".app-c-share-links__title", text: "Share this page"
  end

  test "renders a share link with custom link text correctly" do
    render_component(facebook_href: '/facebook', twitter_href: '/twitter', title: 'Share this article')
    assert_select ".app-c-share-links__title", text: "Share this article"
  end

  test "renders a share link if only one share link provided" do
    render_component(facebook_href: '/facebook')
    assert_select ".app-c-share-links .app-c-share-links__link[href=\"/facebook\"]"
    assert_select ".app-c-share-links .app-c-share-links__link[href=\"/twitter\"]",
      false, "A twitter share link has not been provided so should not have been rendered"
    assert_select ".app-c-share-links .app-c-share-links__link__icon--twitter",
      false, "A twitter share link has not been provided so a twitter icon should not have been rendered"
  end
end
