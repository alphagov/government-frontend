require "test_helper"

class CorporateInformationPageTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item("corporate_information_page_translated_custom_logo")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_text?("Ni all y Gofrestrfa Tir drafod achosion unigol ar ein sianeli cyfryngau cymdeithasol. Ni fyddwn yn gofyn i chi ddatgelu gwybodaeth bersonol na thalu trwy Twitter, Facebook, LinkedIn nac ebost. Os cewch neges o’r fath, peidiwch ag ymateb – nid yw gan y Gofrestrfa Tir a gall fod yn faleisus.")
  end

  test "renders with contents list" do
    setup_and_visit_content_item("corporate_information_page")
    assert_has_contents_list([
      { text: "Our responsibilities", id: "our-responsibilities" },
      { text: "Corporate information", id: "corporate-information" },
    ])
  end

  test "renders corporate information with body when present" do
    setup_and_visit_content_item("corporate_information_page")

    assert page.has_css?("h2#corporate-information")
    assert page.has_css?("h3#access-our-information")
    assert page.has_css?("h3#jobs-and-contracts")

    assert page.has_css?("ul li a[href='/government/organisations/department-of-health/about/complaints-procedure']")
    assert page.has_css?("ul li a[href*='/government/publications']")
    assert page.has_css?("ul li a[href='https://www.civilservicejobs.service.gov.uk/csr']")
  end

  test "renders further information with body when present" do
    setup_and_visit_content_item("corporate_information_page")

    assert page.has_text?("Read about the types of information we routinely")
  end

  test "renders with organisation branding" do
    setup_and_visit_content_item("corporate_information_page")
    assert page.has_css?(".department-of-health-brand-colour")
  end

  test "includes organisation in title" do
    setup_and_visit_content_item("corporate_information_page")
    assert page.has_css?("title", text: "About us - Department of Health - GOV.UK", visible: false)
  end

  test "includes translations" do
    setup_and_visit_content_item("corporate_information_page_translated_custom_logo")
    assert page.has_css?(".gem-c-translation-nav")
  end

  test "renders an organisation logo" do
    setup_and_visit_content_item("corporate_information_page")
    assert_has_component_organisation_logo
  end

  test "renders a custom organisation logo" do
    setup_and_visit_content_item("corporate_information_page_translated_custom_logo")
    assert_has_component_organisation_logo
  end

  test "renders a withdrawal notice on withdrawn page" do
    content_item = GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page")
    content_item["withdrawn_notice"] = {
      'explanation': "This is out of date",
      'withdrawn_at': "2014-08-09T11:39:05Z",
    }
    stub_content_store_has_item("/government/organisations/department-of-health/about", content_item.to_json)

    visit_with_cachebust "/government/organisations/department-of-health/about"

    assert page.has_css?(".gem-c-notice__title", text: "This information page was withdrawn on 9 August 2014")
    assert page.has_css?(".gem-c-notice", text: "This is out of date")
  end

  test "does not render with the single page notification button" do
    setup_and_visit_content_item("corporate_information_page")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
