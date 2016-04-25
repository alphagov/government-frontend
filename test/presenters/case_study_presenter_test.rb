require 'presenter_test_helper'

class CaseStudyPresenterTest < PresenterTest
  include ActionView::Helpers::UrlHelper

  def format_name
    "case_study"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item['description'], presented_item.description
    assert_equal schema_item['format'], presented_item.format
    assert_equal schema_item['locale'], presented_item.locale
    assert_equal schema_item['title'], presented_item.title
    assert_equal schema_item['details']['body'], presented_item.body
    assert_equal schema_item['details']['format_display_type'], presented_item.format_display_type
  end

  test '#published returns a formatted date of the day the content item became public' do
    assert_equal '17 December 2012', presented_item.published
  end

  test '#updated returns nil if the content item has no updates' do
    assert_nil presented_item.updated
  end

  test '#updated returns a formatted date of the last day the content item was updated' do
    assert_equal '21 March 2013', presented_case_study_with_updates.updated
  end

  test '#short_history returns the published day of a non-updated content item' do
    assert_equal 'Published 17 December 2012', presented_item.short_history
  end

  test '#short_history returns the last update day for a content item that has updates' do
    assert_equal 'Updated 21 March 2013', presented_case_study_with_updates.short_history
  end

  test '#from returns links to lead organisations, supporting organisations and worldwide organisations' do
    with_organisations = schema_item
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

    assert_equal expected_from_links, presented_item(format_name, with_organisations).from
  end

  test '#part_of returns an array of document_collections, related policies and world locations' do
    with_extras = schema_item
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
    assert_equal expected_part_of_links, presented_item(format_name, with_extras).part_of
  end

  test '#history returns an empty array if the content item has no updates' do
    assert_equal [], presented_item.history
  end

  test '#history returns a formatted history if the content item has updates' do
    expected_history = [
      { display_time: '21 March 2013', note: 'Something changed', timestamp: '2013-03-21T00:00:00+00:00' },
    ]

    assert_equal expected_history, presented_case_study_with_updates.history
  end

  test '#history returns an empty array if the content item is not published' do
    never_published = schema_item
    never_published['details'].delete('first_public_at')
    presented = CaseStudyPresenter.new(never_published)
    assert_equal [], presented.history
  end

  test 'presents withdrawn notices' do
    example = schema_item("archived")
    presented = presented_item("archived")

    assert example["details"].include?("withdrawn_notice")
    assert presented.withdrawn?
    assert_equal example["details"]["withdrawn_notice"]["explanation"], presented.withdrawal_notice[:explanation]
    assert_equal '<time datetime="2014-08-22T10:29:02+01:00">22 August 2014</time>', presented.withdrawal_notice[:time]
  end

  def presented_case_study_with_updates
    march_21_2013 = DateTime.new(2013, 3, 21).to_s
    with_history = schema_item
    with_history['details']['change_history'] = [{ 'note' => 'Something changed', 'public_timestamp' => march_21_2013 }]
    with_history['public_updated_at'] = march_21_2013

    presented_item(format_name, with_history)
  end
end
