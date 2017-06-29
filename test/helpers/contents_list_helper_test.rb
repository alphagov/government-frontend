require 'test_helper'

class ContentsListHelperTest < ActionView::TestCase
  test "it wraps the number and text in span elements" do
    input = '<a href="#first">1. Thing</a>'
    expected = '<a href="#first"><span class="contents-number">1.</span><span class="contents-text">Thing</span></a>'
    assert_equal expected, wrap_numbers_with_spans(input)
  end

  test "it does nothing if no number is found" do
    input = '<a href="#vision">Vision</a>'
    expected = '<a href="#vision">Vision</a>'
    assert_equal expected, wrap_numbers_with_spans(input)
  end

  test "it does nothing if a number is present but not at the start" do
    input = '<a href="#run-an-effective-welfare-system">Run an effective welfare system part 1. Social Care</a>'
    expected = '<a href="#run-an-effective-welfare-system">Run an effective welfare system part 1. Social Care</a>'
    assert_equal expected, wrap_numbers_with_spans(input)
  end
end
