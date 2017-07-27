require 'component_test_helper'

class SubscriptionLinksTest < ComponentTestCase
  def component_name
    "subscription-links"
  end

  test "renders nothing when no parameters are given" do
    assert_empty render_component({})
  end

  test "renders an email signup link" do
    render_component(email_signup_link: '/email-signup')
    assert_select ".app-c-subscription-links__link--email-alerts[href=\"/email-signup\"]", text: "Get email alerts"
  end

  test "renders a feed link" do
    render_component(feed_link: 'singapore.atom')
    assert_select ".app-c-subscription-links__link--feed[href=\"singapore.atom\"]", text: "Subscribe to feed"
  end

  test "renders both email signup and feed links" do
    render_component(email_signup_link: 'email-signup', feed_link: 'singapore.atom')
    assert_select ".app-c-subscription-links__link--email-alerts[href=\"email-signup\"]", text: "Get email alerts"
    assert_select ".app-c-subscription-links__link--feed[href=\"singapore.atom\"]", text: "Subscribe to feed"
  end
end
