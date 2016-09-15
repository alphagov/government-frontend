require 'test_helper'

class FatalityNoticeTest < ActionDispatch::IntegrationTest
  test "typical fatality notice" do
    setup_and_visit_content_item('fatality_notice')

    assert_has_component_title("Sir George Pomeroy Colley killed in Boer War")

    within(".description") do
      assert_text <<-DESCRIPTION
       It is with great sadness that the Ministry of Defense
       must confirm that Sir George Pomeroy Colley, died in battle
       in Zululand on 27 February 1881.
       DESCRIPTION
    end

    assert_text("Operations in Zululand")
  end
end
