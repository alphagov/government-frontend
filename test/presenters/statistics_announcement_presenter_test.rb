require 'test_helper'

class StatisticsAnnouncementPresenterTest < ActiveSupport::TestCase
  include ActionView::Helpers::UrlHelper

  test 'presents from as links to organisations' do
    links = [
      link_to('NHS England', '/government/organisations/nhs-commissioning-board')
    ]
    assert_equal links, statistics_announcement.from
  end

  test 'presents part_of as links to a topic' do
    links = [
      link_to('National Health Service', '/government/topics/national-health-service')
    ]
    assert_equal links, statistics_announcement.part_of
  end

  test 'presents release_date' do
    assert_equal '20 January 2016 9:30am', statistics_announcement.release_date
  end

  test 'presents previous_release_date' do
    assert_equal '19 January 2016 9:30am', statistics_announcement_date_changed.previous_release_date
  end

  test 'presents release_date_and_status when confirmed' do
    assert_equal '20 January 2016 9:30am (confirmed)', statistics_announcement.release_date_and_status
  end

  test 'presents release_date_and_status when provisional' do
    assert_equal 'January 2016 (provisional)', statistics_announcement_provisional.release_date_and_status
  end

  test 'presents release_date_and_status when cancelled' do
    assert_equal '20 January 2016 9:30am', statistics_announcement_cancelled.release_date_and_status
  end

  test "present other metadata when confirmed" do
    other = {
      "Release date" => "20 January 2016 9:30am (confirmed)"
    }
    assert_equal other, statistics_announcement.other_metadata
  end

  test "present other metadata when cancelled" do
    other = {
      "Proposed release" => "20 January 2016 9:30am",
      "Cancellation date" => "17 January 2016 2:19pm"
    }
    assert_equal other, statistics_announcement_cancelled.other_metadata
  end

  test "shows the cancellation reason when cancelled" do
    item = statistics_announcement_cancelled
    assert_equal "Official Statistics", item.cancellation_reason
  end

  test 'knows if an item is a national statistic' do
    refute statistics_announcement.national_statistics?
    assert statistics_announcement_national.national_statistics?
  end

  test 'knows if the release date has changed' do
    assert statistics_announcement_date_changed.release_date_changed?
    refute statistics_announcement_national.release_date_changed?
  end

  def statistics_announcement_cancelled
    statistics_announcement('cancelled_official_statistics')
  end

  def statistics_announcement_provisional
    statistics_announcement('national_statistics')
  end

  def statistics_announcement_national
    statistics_announcement('national_statistics')
  end

  def statistics_announcement_date_changed
    statistics_announcement('release_date_changed')
  end

  def statistics_announcement(type = 'official_statistics')
    content_item = govuk_content_schema_example('statistics_announcement', type)
    StatisticsAnnouncementPresenter.new(content_item)
  end
end
