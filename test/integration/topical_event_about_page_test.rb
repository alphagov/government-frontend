require 'test_helper'

class TopicalEventAboutPageTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "topical event about pages" do
    setup_and_visit_content_item('topical_event_about_page')
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak("The risk of Ebola to the UK remains low. The virus is only transmitted by direct contact with the blood or bodily fluids of an infected person.")
    assert_has_contents_list([
      { text: "Response in the UK", id: "response-in-the-uk" },
      { text: "Response in Africa", id: "response-in-africa" },
      { text: "Advice for travellers", id: "advice-for-travellers" }
    ])
  end

  test "slim topical event about pages have no contents" do
    setup_and_visit_content_item('slim')
    refute page.has_css?('.contents-list.contents-list-dashed')
  end

  test "contents list not displayed when fewer than three items" do
    @content_item = get_content_example("topical_event_about_page")
    @content_item["details"]["body"] = body_with_two_contents_list_items

    content_store_has_item(@content_item["base_path"], @content_item.to_json)

    visit @content_item["base_path"]
    refute page.has_css?(".gem-c-contents-list")
  end

  test "contents list displayed when fewer than three items and first item word count is greater than 100" do
    @content_item = get_content_example("topical_event_about_page")
    @content_item["details"]["body"] = long_first_item_body

    content_store_has_item(@content_item["base_path"], @content_item.to_json)

    visit @content_item["base_path"]
    assert page.has_css?(".gem-c-contents-list")
  end

private

  def topical_event_end_date
    Date.parse(@content_item['links']['parent'][0]['details']['end_date'])
  end

  def long_first_item_body
    "<div class='govspeak'><h2 id='response-in-the-uk'>Item 1</h2>
    <p>#{Faker::Lorem.characters(200)}</p>
    <p>#{Faker::Lorem.characters(216)}</p>
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
