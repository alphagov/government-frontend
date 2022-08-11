require "test_helper"

class ManualsHelperTest < ActionView::TestCase
  test "it returns an empty string when given an empty string" do
    expected = ""
    actual = ""
    assert_equal(expected, sanitize_manual_update_title(actual))
  end

  test "it returns an empty string when given nil" do
    expected = ""
    actual = nil
    assert_equal(expected, sanitize_manual_update_title(actual))
  end

  test "it removes HTML from the title" do
    expected = "Hello world"
    actual = " <h1> Hello world </h1> "
    assert_equal(expected, sanitize_manual_update_title(actual))
  end

  test "it removes the manuals.updates_amendments string from the title" do
    expected = "Hello world"
    actual = " <h1> Hello world </h1> <span> #{I18n.t('manuals.updates_amendments')} </span> "
    assert_equal(expected, sanitize_manual_update_title(actual))
  end

  test "it only the unrequired elements from the title" do
    expected = "Hello world ABC XYZ"
    actual = " <h1> Hello world </h1> <span> ABC #{I18n.t('manuals.updates_amendments')} XYZ </span> "
    assert_equal(expected, sanitize_manual_update_title(actual))
  end
end
