require 'test_helper'

class StatisticalDataSetTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item('statistical_data_set')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "renders publisher metadata" do
    setup_and_visit_content_item('statistical_data_set')

    within(".app-c-publisher-metadata") do
      within(".app-c-publisher-metadata__other") do
        assert page.has_content?("From: Department for Transport")
        assert page.has_link?('Department for Transport', href: '/government/organisations/department-for-transport')
      end
      within(".app-c-published-dates") do
        assert page.has_content?("Published 13 December 2012")
      end
    end
  end

  test "renders withdrawn notification" do
    setup_and_visit_content_item("statistical_data_set_withdrawn")

    assert page.has_css?('title', text: "[Withdrawn]", visible: false)

    withdrawn_notice_explanation = @content_item["withdrawn_notice"]["explanation"]
    withdrawn_at = @content_item["withdrawn_notice"]["withdrawn_at"]

    within ".app-c-notice" do
      assert page.has_text?("This statistical data set was withdrawn"), "is withdrawn"
      assert_has_component_govspeak(withdrawn_notice_explanation)
      assert page.has_css?("time[datetime='#{withdrawn_at}']")
    end
  end

  test "historically political statistical data set" do
    setup_and_visit_content_item('statistical_data_set_political')

    within ".app-c-banner" do
      assert page.has_text?('This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government')
    end
  end
end
