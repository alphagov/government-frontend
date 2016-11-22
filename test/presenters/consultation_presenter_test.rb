require 'presenter_test_helper'

class ConsultationPresenterTest
  class PresentedConsultation < PresenterTestCase
    def format_name
      "consultation"
    end

    test 'presents the format' do
      assert_equal schema_item("open_consultation")['document_type'], presented_item("open_consultation").document_type
      assert_equal schema_item("open_consultation")['details']['body'], presented_item("open_consultation").body
    end

    test 'presents friendly dates for opening and closing dates, including time' do
      assert_equal "10am on 4 November 2016", presented_item("open_consultation").opening_date
      assert_equal "4pm on 16 December 2216", presented_item("open_consultation").closing_date
    end

    test 'presents 12am as 11:59pm on the day before' do
      schema = schema_item("open_consultation")
      schema['details']['opening_date'] = "2016-11-04T00:00:00+01:00"
      schema['details']['closing_date'] = "2016-11-04T00:01:00+01:00"
      presented = presented_item("open_consultation", schema)

      assert_equal "11:59pm on 3 November 2016", presented.opening_date
      assert_equal "12:01am on 4 November 2016", presented.closing_date
    end

    test 'presents 12pm as midday' do
      schema = schema_item("open_consultation")
      schema['details']['opening_date'] = "2016-11-04T12:00:00+01:00"
      presented = presented_item("open_consultation", schema)

      assert_equal "midday on 4 November 2016", presented.opening_date
    end

    test 'presents open and closed states' do
      assert presented_item("open_consultation").open?
      refute presented_item("open_consultation").closed?

      assert presented_item("closed_consultation").closed?
      refute presented_item("closed_consultation").open?

      assert presented_item("consultation_outcome").closed?
      refute presented_item("consultation_outcome").open?
    end

    test 'presents consultation documents' do
      presented = presented_item("closed_consultation")
      schema = schema_item("closed_consultation")

      assert presented.documents?
      assert_equal schema['details']['documents'].join(''), presented.documents
    end

    test 'presents final outcome documents' do
      presented = presented_item("consultation_outcome")
      schema = schema_item("consultation_outcome")

      assert presented.final_outcome_documents?
      assert_equal schema['details']['final_outcome_documents'].join(''), presented.final_outcome_documents
    end

    test 'presents URL for consultations held on another website' do
      assert presented_item("open_consultation").held_on_another_website?
      refute presented_item("closed_consultation").held_on_another_website?

      assert_equal "https://consult.education.gov.uk/part-time-maintenance-loans/post-graduate-doctoral-loans/", presented_item("open_consultation").held_on_another_website_url
      refute presented_item("closed_consultation").held_on_another_website_url
    end
  end
end
