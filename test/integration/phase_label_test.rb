require 'test_helper'

class PhaseLabelTest < ActionDispatch::IntegrationTest
  test "Alpha phase label is displayed for a Case Study in phase 'alpha'" do
    case_study = JSON.parse(GovukContentSchemaTestHelpers::Examples.new.get('case_study', 'case_study'))
    case_study.merge!("phase" => "alpha")
    content_store_has_item("/government/case-studies/get-britain-building-carlisle-park", case_study.to_json)

    visit "/government/case-studies/get-britain-building-carlisle-park"

    assert_has_phase_label "alpha"
  end

  test "No phase label is displayed for a Content item without a phase field" do
    content_item = JSON.parse(GovukContentSchemaTestHelpers::Examples.new.get('case_study', 'case_study'))
    content_item.delete("phase")
    content_store_has_item("/government/case-studies/get-britain-building-carlisle-park", content_item.to_json)

    visit "/government/case-studies/get-britain-building-carlisle-park"

    assert page.has_no_css?("[data-template='govuk_component-alpha_label']")
    assert page.has_no_css?("[data-template='govuk_component-beta_label']")
  end

  def assert_has_phase_label(phase)
    within "[data-template='govuk_component-#{phase}_label']" do
      assert page.has_content?("#{phase}_label"), "Expected the page to have an '#{phase.titleize}' label"
    end
  end
end
