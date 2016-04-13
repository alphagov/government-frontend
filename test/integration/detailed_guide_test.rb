require 'test_helper'

class DetailedGuideTest < ActionDispatch::IntegrationTest
  test "detailed guide" do
    setup_and_visit_content_item('detailed_guide')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert_has_component_metadata_pair("First published", "12 June 2014")
    assert_has_component_metadata_pair("Last updated", "18 February 2016") #TODO: add "see all updates"
    assert_has_component_metadata_pair("Part of", "PAYE") #TODO: add "and Business Tax"
  end
end
