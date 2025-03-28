require "test_helper"

class ServiceManualPhaseLabelTest < ActionDispatch::IntegrationTest
  test "renders custom message for service manual guide pages" do
    guide = govuk_content_schema_example("service_manual_guide", "service_manual_guide")
    guide["phase"] = "beta"
    guide["base_path"] = "/service-manual/beta"
    stub_content_store_has_item(guide["base_path"], guide)
    visit guide["base_path"]

    assert page.has_content?("Contact the Service Manual team")
  end

  test "alpha phase label is displayed for a guide in phase 'alpha'" do
    guide = govuk_content_schema_example("service_manual_guide", "service_manual_guide")
    guide["phase"] = "alpha"
    guide["base_path"] = "/service-manual/alpha"
    stub_content_store_has_item(guide["base_path"], guide)
    visit guide["base_path"]

    phase_label = find("strong.govuk-tag.govuk-phase-banner__content__tag").text

    assert_match(/alpha/i, phase_label.strip)
  end

  test "No phase label is displayed for a guide without a phase field" do
    guide = govuk_content_schema_example("service_manual_guide", "service_manual_guide")
    guide["phase"] = nil
    stub_content_store_has_item(guide["base_path"], guide)
    visit guide["base_path"]

    assert_not page.has_content?("Contact the Service Manual team")
  end
end
