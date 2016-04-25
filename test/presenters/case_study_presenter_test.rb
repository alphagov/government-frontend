require 'test_helper'

class CaseStudyPresenterTest < ActiveSupport::TestCase
  include ActionView::Helpers::UrlHelper

  test 'presents the basic details of a content item' do
    assert_equal case_study['description'], presented_case_study.description
    assert_equal case_study['format'], presented_case_study.format
    assert_equal case_study['locale'], presented_case_study.locale
    assert_equal case_study['title'], presented_case_study.title
    assert_equal case_study['details']['body'], presented_case_study.body
    assert_equal case_study['details']['format_display_type'], presented_case_study.format_display_type
  end

  test '#published returns a formatted date of the day the content item became public' do
    assert_equal '17 December 2012', presented_case_study.published
  end

  test '#updated returns nil if the content item has no updates' do
    assert_nil presented_case_study.updated
  end

  test '#updated returns a formatted date of the last day the content item was updated' do
    assert_equal '21 March 2013', presented_case_study_with_updates.updated
  end

  test '#short_history returns the published day of a non-updated content item' do
    assert_equal 'Published 17 December 2012', presented_case_study.short_history
  end

  test '#short_history returns the last update day for a content item that has updates' do
    assert_equal 'Updated 21 March 2013', presented_case_study_with_updates.short_history
  end

  test '#from returns links to lead organisations, supporting organisations and worldwide organisations' do
    with_organisations = case_study
    with_organisations['links']['lead_organisations'] = [
      { "title" => 'Lead org', "base_path" => '/orgs/lead' }
    ]
    with_organisations['links']['supporting_organisations'] = [
      { "title" => 'Supporting org', "base_path" => '/orgs/supporting' }
    ]

    expected_from_links = [
      link_to('Lead org', '/orgs/lead'),
      link_to('Supporting org', '/orgs/supporting'),
      link_to('DFID Pakistan', '/government/world/organisations/dfid-pakistan'),
    ]

    assert_equal expected_from_links, presented_case_study(with_organisations).from
  end

  test '#part_of returns an array of document_collections, related policies and world locations' do
    with_extras = case_study
    with_extras['links']['document_collections'] = [
      { "title" => "Work Programme real life stories", "base_path" => "/government/collections/work-programme-real-life-stories" }
    ]
    with_extras['links']['related_policies'] = [
      { "title" => "Cheese", "base_path" => "/policy/cheese" }
    ]

    expected_part_of_links = [
      link_to('Work Programme real life stories', '/government/collections/work-programme-real-life-stories'),
      link_to('Cheese', '/policy/cheese'),
      link_to('Pakistan', '/government/world/pakistan'),
    ]
    assert_equal expected_part_of_links, presented_case_study(with_extras).part_of
  end

  test '#history returns an empty array if the content item has no updates' do
    assert_equal [], presented_case_study.history
  end

  test '#history returns a formatted history if the content item has updates' do
    expected_history = [
      { display_time: '21 March 2013', note: 'Something changed', timestamp: '2013-03-21T00:00:00+00:00' },
    ]

    assert_equal expected_history, presented_case_study_with_updates.history
  end

  test '#history returns an empty array if the content item is not published' do
    never_published = case_study
    never_published['details'].delete('first_public_at')
    presented = CaseStudyPresenter.new(never_published)
    assert_equal [], presented.history
  end

  def presented_case_study(overrides = {})
    CaseStudyPresenter.new(case_study.merge(overrides))
  end

  def presented_case_study_with_updates
    march_21_2013 = DateTime.new(2013, 3, 21).to_s
    with_history = case_study
    with_history['details']['change_history'] = [{ 'note' => 'Something changed', 'public_timestamp' => march_21_2013 }]
    with_history['public_updated_at'] = march_21_2013

    presented_case_study(with_history)
  end

  def case_study
    govuk_content_schema_example('case_study', 'case_study')
  end
end
