require 'test_helper'

class CorporateInformationPageTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item('corporate_information_page_translated_custom_logo')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "renders with contents list" do
    setup_and_visit_content_item('corporate_information_page')
    assert_has_contents_list([
      { text: "Our responsibilities", id: "our-responsibilities" },
      { text: "Corporate information", id: "corporate-information" },
    ])
  end

  test "renders corporate information with body when present" do
    setup_and_visit_content_item('corporate_information_page')

    within_component_govspeak do |component_args|
      content = component_args.fetch("content")
      assert content.gsub(/\s+/, ' ').include? @content_item["details"]["body"].gsub(/\s+/, ' ')

      html = Nokogiri::HTML.parse(content)
      assert_not_nil html.at_css("h2#corporate-information")
      assert_not_nil html.at_css("h3#access-our-information")
      assert_not_nil html.at_css("h3#jobs-and-contracts")

      assert_not_nil html.at_css("ul li a[href='/government/organisations/department-of-health/about/complaints-procedure']")
      assert_not_nil html.at_css("ul li a[href*='/government/publications']")
      assert_not_nil html.at_css("ul li a[href='https://www.civilservicejobs.service.gov.uk/csr']")
    end
  end

  test "renders further information with body when present" do
    setup_and_visit_content_item('corporate_information_page')

    within_component_govspeak do |component_args|
      content = component_args.fetch("content")
      assert content.gsub(/\s+/, ' ').include? "Read about the types of information we routinely"
    end
  end

  test "renders with organisation branding" do
    setup_and_visit_content_item('corporate_information_page')
    assert page.has_css?('.department-of-health-brand-colour')
  end

  test "includes organisation in title" do
    setup_and_visit_content_item('corporate_information_page')
    assert page.has_css?('title', text: 'About us - Department of Health - GOV.UK', visible: false)
  end

  test "includes translations" do
    setup_and_visit_content_item('corporate_information_page_translated_custom_logo')
    assert page.has_css?('.available-languages')
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

  test "renders a custom organisation logo" do
    setup_and_visit_content_item('corporate_information_page_translated_custom_logo')
    assert_has_component_organisation_logo(
      organisation: {
        name: 'Land Registry',
        url: '/government/organisations/land-registry',
        brand: 'department-for-business-innovation-skills',
        crest: nil,
        image: {
          url: 'https://assets.publishing.service.gov.uk/government/uploads/system/uploads/organisation/logo/69/LR_logo_265.png',
          alt_text: 'Land Registry'
        }
      }
    )
  end
end
