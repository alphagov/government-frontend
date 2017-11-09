require 'component_test_helper'

class PublishedDatesTest < ComponentTestCase
  def component_name
    "published-dates"
  end

  test "renders nothing when no dates are provided" do
    assert_empty(render_component({}))
  end

  test "renders published date" do
    render_component(published: "1st November 2000")
    assert_select ".app-c-published-dates", text: "Published 1st November 2000"
  end

  test "renders published date and last updated date" do
    render_component(published: "1st November 2000", last_updated: "15th July 2015")
    assert_select ".app-c-published-dates", text: "Published 1st November 2000
    Last updated 15th July 2015"
  end

  test "links to full page history" do
    render_component(published: "1st November 2000", last_updated: "15th July 2015", link_to_history: true)
    assert_select ".app-c-published-dates a[href=\"#history\"]"
  end

  test "renders full page history" do
    render_component(
      published: "1st November 2000",
      last_updated: "15th July 2015",
      history: [display_time: "23 August 2013", note: "Updated with new data"]
    )
    assert_select ".app-c-published-dates__change-history#full-history"
    assert_select ".app-c-published-dates .app-c-published-dates__change-date", text: "23 August 2013"
  end

  test "full page history is hidden on page load" do
    render_component(
      published: "1st November 2000",
      last_updated: "15th July 2015",
      history: [display_time: "23 August 2013", note: "Updated with new data"]
    )
    assert_select ".app-c-published-dates__change-history.js-hidden"
  end

  test "renders link to full page history if history is provided" do
    render_component(
      published: "1st November 2000",
      last_updated: "15th July 2015",
      history: [display_time: "23 August 2013", note: "Updated with new data"]
    )
    assert_select ".app-c-published-dates a[href=\"#full-history\"]"
  end

  test "includes data attributes for toggle behaviour" do
    render_component(
      published: "1st November 2000",
      last_updated: "15th July 2015",
      history: [display_time: "23 August 2013", note: "Updated with new data"]
    )
    assert_select ".app-c-published-dates[data-module=\"toggle\"]"
    assert_select ".app-c-published-dates a[href=\"#full-history\"][data-controls=\"full-history\"]"
    assert_select ".app-c-published-dates a[href=\"#full-history\"][data-expanded=\"false\"]"
  end
end
