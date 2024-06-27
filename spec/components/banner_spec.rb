RSpec.describe("Banner", type: :view) do
  def component_name
    "banner"
  end

  it "raises an error when no parameters given" do
    expect { render_component({}) }.to raise_error(ActionView::Template::Error)
  end

  it "renders with text" do
    render_component(title: "Summary", text: "This was published under the 2010 to 2015 Conservative government")

    assert_select(".app-c-banner--aside", false)
    assert_select(".app-c-banner__desc", text: "This was published under the 2010 to 2015 Conservative government")
  end

  it "renders with an aria label" do
    render_component(title: "Summary", text: "Text")

    assert_select("section[aria-label]")
  end

  it "renders with title and text" do
    render_component(title: "Summary", text: "This was published under the 2010 to 2015 Conservative government")

    assert_select(".app-c-banner--aside", false)
    assert_select(".app-c-banner__title", text: "Summary")
    assert_select(".app-c-banner__desc", text: "This was published under the 2010 to 2015 Conservative government")
  end

  it "renders with title, text and aside" do
    render_component(title: "Summary", text: "This was published under the 2010 to 2015 Conservative government", aside: "This consultation ran from 9:30am on 30 January 2017 to 5pm on 28 February 2017")

    assert_select(".app-c-banner--aside")
    assert_select(".app-c-banner__title", text: "Summary")
    assert_select(".app-c-banner__desc", text: "This was published under the 2010 to 2015 Conservative government")
    assert_select(".app-c-banner__desc", text: "This consultation ran from 9:30am on 30 January 2017 to 5pm on 28 February 2017")
  end

  it "renders with GA4 tracking" do
    render_component(title: "Summary", text: "This was published under the 2010 to 2015 Conservative government", aside: "This consultation ran from 9:30am on 30 January 2017 to 5pm on 28 February 2017")

    assert_select(".app-c-banner--aside[data-module=ga4-link-tracker]")
    assert_select(".app-c-banner--aside[data-ga4-track-links-only]")
    assert_select(".app-c-banner--aside[data-ga4-link='{\"event_name\":\"navigation\",\"type\":\"callout\"}']")
  end
end
