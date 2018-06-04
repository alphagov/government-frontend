require 'test_helper'

class TakePartTest < ActionDispatch::IntegrationTest
  test "take part pages" do
    setup_and_visit_content_item('take_part')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert_has_component_govspeak("There are roughly 20,000 local councillors in England. Councillors are elected to the local council to represent their own local community, so they must either live or work in the area.")
  end
end
