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

    test 'has contents list' do
      assert presented_item.is_a?(ContentsList)
    end

    test 'has organisation branding' do
      assert presented_item.is_a?(OrganisationBranding)
    end
  end
end
