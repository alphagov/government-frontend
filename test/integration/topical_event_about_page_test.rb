require "test_helper"

class TopicalEventAboutPageTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    assert_nothing_raised { setup_and_visit_random_content_item }
  end

  test "topical event about pages" do
    setup_and_visit_content_item("topical_event_about_page")
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_text?("The risk of Ebola to the UK remains low. The virus is only transmitted by direct contact with the blood or bodily fluids of an infected person.")
    assert_has_contents_list([
      { text: "Response in the UK", id: "response-in-the-uk" },
      { text: "Response in Africa", id: "response-in-africa" },
      { text: "Advice for travellers", id: "advice-for-travellers" },
    ])
  end

  test "slim topical event about pages have no contents" do
    setup_and_visit_content_item("slim")
    assert_not page.has_css?(".contents-list.contents-list-dashed")
  end

  test "renders a content list" do
    setup_and_visit_content_item("topical_event_about_page")
    assert page.has_css?(".gem-c-contents-list", text: "Contents")
  end

  test "contents list displayed when fewer than three items and first item word count is greater than 100" do
    @content_item = get_content_example("topical_event_about_page")
    @content_item["details"]["body"] = long_first_item_body

    stub_content_store_has_item(@content_item["base_path"], @content_item.to_json)

    visit_with_cachebust @content_item["base_path"]
    assert page.has_css?(".gem-c-contents-list")
  end

  test "does not render with the single page notification button" do
    setup_and_visit_content_item("topical_event_about_page")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end

private

  def topical_event_end_date
    Date.parse(@content_item["links"]["parent"][0]["details"]["end_date"])
  end

  def long_first_item_body
    "<div class='govspeak'><h2 id='response-in-the-uk'>Item 1</h2>
    <p>#{Faker::Lorem.characters(number: 200)}</p>
    <p>#{Faker::Lorem.characters(number: 216)}</p>
    <h2 id='response-in-africa'>Item 2</h2>
    <p>#{Faker::Lorem.sentence}</p></div>"
  end

  def body_with_two_contents_list_items
    "<div class='govspeak'>
    <h2 id='response-in-the-uk'>Item 1</h2>
    <p>Content about item 1</p>
    <h2 id='response-in-africa'>Item 2</h2>
    <p>Content about item 2</p></div>"
  end
end
