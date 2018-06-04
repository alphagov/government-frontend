require 'test_helper'

class CorporateInformationPageTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item('corporate_information_page_translated_custom_logo')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_text?("Ni all y Gofrestrfa Tir drafod achosion unigol ar ein sianeli cyfryngau cymdeithasol. Ni fyddwn yn gofyn i chi ddatgelu gwybodaeth bersonol na thalu trwy Twitter, Facebook, LinkedIn nac ebost. Os cewch neges o’r fath, peidiwch ag ymateb – nid yw gan y Gofrestrfa Tir a gall fod yn faleisus.")
  end

  test "renders with contents list" do
    setup_and_visit_content_item('corporate_information_page')
    assert_has_contents_list([
      { text: "Our responsibilities", id: "our-responsibilities" },
      { text: "Corporate information", id: "corporate-information" },
    ])
  end

  test "renders without contents list if it has fewer than 3 items" do
    item = get_content_example("corporate_information_page")
    item["details"]["body"] = "<div class='govspeak'>
      <h2>Item one</h2><p>Content about item one</p>
      <h2>Item two</h2><p>Content about item two</p>
      </div>"

    content_store_has_item(item["base_path"], item.to_json)
    visit(item["base_path"])

    refute page.has_css?(".gem-c-contents-list")
  end

  test "renders corporate information with body when present" do
    setup_and_visit_content_item('corporate_information_page')

    assert page.has_css?("h2#corporate-information")
    assert page.has_css?("h3#access-our-information")
    assert page.has_css?("h3#jobs-and-contracts")

    assert page.has_css?("ul li a[href='/government/organisations/department-of-health/about/complaints-procedure']")
    assert page.has_css?("ul li a[href*='/government/publications']")
    assert page.has_css?("ul li a[href='https://www.civilservicejobs.service.gov.uk/csr']")
  end

  test "renders further information with body when present" do
    setup_and_visit_content_item('corporate_information_page')

    assert page.has_text?("Read about the types of information we routinely")
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
    assert page.has_css?('.gem-c-translation-nav')
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

  test 'renders a withdrawal notice on withdrawn page' do
    content_item = GovukSchemas::Example.find('corporate_information_page', example_name: 'corporate_information_page')
    content_item['withdrawn_notice'] = {
      'explanation': 'This is out of date',
      'withdrawn_at': '2014-08-09T11:39:05Z'
    }
    content_store_has_item("/government/organisations/department-of-health/about", content_item.to_json)

    visit "/government/organisations/department-of-health/about"

    assert page.has_css?(".gem-c-notice__title", text: "This information page was withdrawn on 9 August 2014")
    assert page.has_css?(".gem-c-notice", text: "This is out of date")
  end
end
