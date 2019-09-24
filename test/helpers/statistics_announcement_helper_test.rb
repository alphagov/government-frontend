require "test_helper"

class StatisticsAnnouncementHelperTest < ActionView::TestCase
  test "returns 'on' if the date is an exact format" do
    assert_equal "on 10 January 2017 9:30am", on_in_between_for_release_date("10 January 2017 9:30am")
    assert_equal "on 1 December 2010 11:30pm", on_in_between_for_release_date("1 December 2010 11:30pm")
    assert_equal "on 18 March 2020 1:30PM", on_in_between_for_release_date("18 March 2020 1:30PM")
  end

  test "returns 'in' if the date is a one month format" do
    assert_equal "in January 2018", on_in_between_for_release_date("January 2018")
  end

  test "returns 'between' and replaces 'to' with 'and' if the date is a two month format" do
    assert_equal "between March and April 2018", on_in_between_for_release_date("March to April 2018")
  end

  test "returns the passed in string if it doesn't match any format" do
    assert_equal "some or other unexpected date format", on_in_between_for_release_date("some or other unexpected date format")
  end
end
