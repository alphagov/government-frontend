require 'presenter_test_helper'

class StatisticsAnnouncementPresenterTest < PresenterTestCase
  include ActionView::Helpers::UrlHelper

  def schema_name
    "statistics_announcement"
  end

  test 'presents from as links to organisations' do
    links = [
      link_to('NHS England', '/government/organisations/nhs-commissioning-board')
    ]
    assert_equal links, statistics_announcement.from
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

  test "present important metadata when confirmed" do
    metadata = {
      "Release date" => "20 January 2016 9:30am (confirmed)"
    }
    assert_equal metadata, statistics_announcement.important_metadata
  end

  test "present important metadata when cancelled" do
    metadata = {
      "Proposed release" => "20 January 2016 9:30am",
      "Cancellation date" => "17 January 2016 2:19pm"
    }
    assert_equal metadata, statistics_announcement_cancelled.important_metadata
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

  test 'an announcement is forthcoming if it is not cancelled' do
    assert statistics_announcement.forthcoming_publication?
  end

  test 'a cancelled announcement takes precedence over a forthcoming announcement' do
    refute statistics_announcement_cancelled.forthcoming_publication?
  end

  def statistics_announcement_cancelled
    presented_item('cancelled_official_statistics')
  end

  def statistics_announcement_provisional
    presented_item('national_statistics')
  end

  def statistics_announcement_national
    presented_item('national_statistics')
  end

  def statistics_announcement_date_changed
    presented_item('release_date_changed')
  end

  def statistics_announcement
    presented_item('official_statistics')
  end
end
