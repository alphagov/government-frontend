require "test_helper"

class PhaseLabelTest < ActionDispatch::IntegrationTest
  test "renders custom message for service manual guide pages" do
    guide = content_store_has_schema_example(
      "service_manual_guide",
      "service_manual_guide",
      phase: "beta",
    )

    visit guide["base_path"]

    assert page.has_content?("Contact the Service Manual team")
  end

  test "renders custom message for service manual homepage" do
    homepage = content_store_has_schema_example(
      "service_manual_homepage",
      "service_manual_homepage",
    )

    visit homepage["base_path"]

    assert page.has_content?("Contact the Service Manual team")
  end

  test "alpha phase label is displayed for a guide in phase 'alpha'" do
    guide = content_store_has_schema_example(
      "service_manual_guide",
      "service_manual_guide",
      phase: "alpha",
    )

    visit guide["base_path"]

    assert page.has_content?("alpha")
  end

  test "No phase label is displayed for a guide without a phase field" do
    guide = content_store_has_schema_example(
      "service_manual_guide",
      "service_manual_guide",
      phase: nil,
    )

    visit guide["base_path"]

    assert_not page.has_content?("Contact the Service Manual team")
  end
end
