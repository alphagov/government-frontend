require 'test_helper'

class TopicalEventAboutPageTest < ActionDispatch::IntegrationTest
  test "topical event about pages" do
    setup_and_visit_content_item('topical_event_about_page')
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
    assert_has_contents([
      { text: "Response in the UK", id: "response-in-the-uk" },
      { text: "Response in Africa", id: "response-in-africa" },
      { text: "Advice for travellers", id: "advice-for-travellers" }
    ])
  end

  test "breadcrumbs show whether a topical event is archived" do
    @content_item = JSON.parse(get_content_example("topical_event_about_page"))
    content_store_has_item(@content_item["base_path"], @content_item.to_json)

    breadcrumbs = [
                      {
                        title: "Home",
                        url: "/"
                      },
                      {
                        title: @content_item["links"]["parent"][0]["title"],
                        url: @content_item["links"]["parent"][0]["base_path"]
                      },
                  ]

    travel_to(topical_event_end_date - 1) do
      visit @content_item["base_path"]
      assert_has_component_breadcrumbs(breadcrumbs)
    end

    travel_to(topical_event_end_date) do
      visit @content_item["base_path"]
      breadcrumbs[1].merge!(title: @content_item["links"]["parent"][0]["title"] + " (Archived)")
      assert_has_component_breadcrumbs(breadcrumbs)
    end
  end

  test "slim topical event about pages have no contents" do
    setup_and_visit_content_item('slim')
    refute page.has_css?('.dash-list')
  end

private

  def topical_event_end_date
    Date.parse(@content_item['links']['parent'][0]['details']['end_date'])
  end
end
