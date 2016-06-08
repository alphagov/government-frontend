require 'test_helper'

class CaseStudyTest < ActionDispatch::IntegrationTest
  test "translated case study" do
    setup_and_visit_content_item('translated')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert page.has_css?('.available-languages')
  end

  test "withdrawn case study" do
    setup_and_visit_content_item('archived')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within ".withdrawal-notice" do
      assert page.has_text?('This case study was withdrawn'), "is withdrawn"
      assert_has_component_govspeak(@content_item["withdrawn_notice"]["explanation"])
      assert page.has_css?("time[datetime='#{@content_item['withdrawn_notice']['withdrawn_at']}']")
    end
  end
end
