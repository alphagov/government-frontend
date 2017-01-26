require 'test_helper'

class CorporateInformationPageTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item('corporate_information_page')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])

    assert_has_contents_list([
      { text: "Our responsibilities", id: "our-responsibilities" },
    ])
  end

  test "renders with organisation branding" do
    setup_and_visit_content_item('corporate_information_page')
    assert page.has_css?('.department-of-health-brand-colour')
  end

  test "renders an organisation logo" do
    setup_and_visit_content_item('corporate_information_page')
    assert_has_component_organisation_logo(
      organisation: {
        name: 'Department<br/>of Health',
        url: '/government/organisations/department-of-health',
        brand: 'department-of-health',
        crest: 'single-identity'
      }
    )
  end
end
