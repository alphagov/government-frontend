require 'component_test_helper'

class BannerTest < ComponentTestCase
  def component_name
    "banner"
  end

  test "fails to render a banner when no text is given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders a banner with text correctly" do
    render_component(title: 'Summary', text: 'This was published under the 2010 to 2015 Conservative government')

    assert_select ".app-c-banner--grid", false
    assert_select ".app-c-banner__desc", text: 'This was published under the 2010 to 2015 Conservative government'
  end

  test "renders a banner with title and text correctly" do
    render_component(title: 'Summary', text: 'This was published under the 2010 to 2015 Conservative government')

    assert_select ".app-c-banner--grid", false
    assert_select ".app-c-banner__title", text: 'Summary'
    assert_select ".app-c-banner__desc", text: 'This was published under the 2010 to 2015 Conservative government'
  end

  test "renders a banner with title, text and aside correctly" do
    render_component(title: 'Summary',
                      text: 'This was published under the 2010 to 2015 Conservative government',
                      aside: 'This consultation ran from 9:30am on 30 January 2017 to 5pm on 28 February 2017')

    assert_select ".app-c-banner--grid"
    assert_select ".app-c-banner__title", text: 'Summary'
    assert_select ".app-c-banner__desc", text: 'This was published under the 2010 to 2015 Conservative government'
    assert_select ".app-c-banner__aside p", text: 'This consultation ran from 9:30am on 30 January 2017 to 5pm on 28 February 2017'
  end
end
