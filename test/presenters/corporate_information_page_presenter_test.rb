require 'presenter_test_helper'

class CorporateInformationPagePresenterTest
  class PresentedCorporateInformationPage < PresenterTestCase
    def format_name
      "corporate_information_page"
    end

    test 'presents the body' do
      assert_equal schema_item['details']['body'], presented_item.body
    end

    test 'presents the organisation in the title' do
      assert_equal "About us - Department of Health", presented_item.page_title
    end

    test 'does not present an organisation in the title when it is not present in links' do
      presented_item = presented_item(format_name, "links" => {})
      assert_equal "About us", presented_item.page_title
    end

    test 'has contents list' do
      assert presented_item.is_a?(ContentsList)
    end

    test 'has title without context' do
      assert presented_item.is_a?(TitleAndContext)
      title_component_params = { title: "About us" }

      assert_equal title_component_params, presented_item.title_and_context
    end

    test 'has organisation branding' do
      assert presented_item.is_a?(OrganisationBranding)
    end

    test 'presents corporate information groups on about pages' do
      assert presented_item.is_a?(CorporateInformationGroups)

      assert_equal '<a data-track-category="contentsClicked" data-track-action="leftColumnH2" data-track-label="corporate-information" href="#corporate-information">Corporate information</a>', presented_item.contents.last

      assert presented_item.corporate_information?
    end

    test 'presents group links that are guids' do
      presented_groups = presented_item.corporate_information
      assert_equal '<a href="/government/organisations/department-of-health/about/complaints-procedure">Complaints procedure</a>', presented_groups.first[:links].first
    end

    test 'presents group links that are internal links with paths and no GUID' do
      presented_groups = presented_item.corporate_information
      assert_equal '<a href="/government/publications?departments%5B%5D=department-of-health&amp;publication_type=corporate-reports">Corporate reports</a>', presented_groups.first[:links].last
    end

    test 'presents group links that are external' do
      presented_groups = presented_item.corporate_information
      assert_equal '<a href="https://www.civilservicejobs.service.gov.uk/csr">Jobs</a>', presented_groups.last[:links].last
    end

    test 'presents group headings' do
      presented_groups = presented_item.corporate_information
      assert_equal '<h3 id="access-our-information">Access our information</h3>', presented_groups.first[:heading]
    end

    test 'presents further information based on corporate information page links' do
      publication_scheme = schema_item['links']['corporate_information_pages'].find { |l| l['document_type'] == 'publication_scheme' }
      information_charter = schema_item['links']['corporate_information_pages'].find { |l| l['document_type'] == 'personal_information_charter' }

      assert presented_item.further_information.include?(publication_scheme['base_path'])
      assert presented_item.further_information.include?(publication_scheme['title'])
      assert presented_item.further_information.include?(information_charter['base_path'])
      assert presented_item.further_information.include?(information_charter['title'])
    end
  end
end
