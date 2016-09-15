require 'test_helper'

class FatalityNoticeTest < ActionDispatch::IntegrationTest
  test "typical fatality notice" do
    setup_and_visit_content_item('fatality_notice')

    assert_component_parameter("title", "context", "Operations in Zululand")
    assert_has_component_title("Sir George Pomeroy Colley killed in Boer War")

    assert_has_component_metadata_pair(
      "from",
      ["<a href=\"/government/organisations/ministry-of-defence\">Ministry of Defence</a>"]
    )

    assert_has_component_metadata_pair(
      "Field of operation",
      "<a href=\"/government/fields-of-operation/zululand\">Zululand</a>"
    )

    within(".description") do
      assert_text <<-DESCRIPTION
       It is with great sadness that the Ministry of Defense
       must confirm that Sir George Pomeroy Colley, died in battle
       in Zululand on 27 February 1881.
       DESCRIPTION
    end
  end
end
