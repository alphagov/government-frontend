require 'test_helper'

class ContentsListHelperTest < ActionView::TestCase
  test "it wraps a number and text in separate span elements" do
    input = '<a href="#first">1. Thing</a>'
    expected = '<a href="#first"><span class="contents-number">1.</span><span class="contents-text">Thing</span></a>'
    assert_equal expected, wrap_numbers_with_spans(input)

    input = '<a href="#vision">10. Vision</a>'
    expected = '<a href="#vision"><span class="contents-number">10.</span><span class="contents-text">Vision</span></a>'
    assert_equal expected, wrap_numbers_with_spans(input)

    input = '<a href="#vision">100. Vision</a>'
    expected = '<a href="#vision"><span class="contents-number">100.</span><span class="contents-text">Vision</span></a>'
    assert_equal expected, wrap_numbers_with_spans(input)
  end

  test "it wraps a number and text in span elements if it's a number without a period" do
    input = '<a href="#first">1 Thing</a>'
    expected = '<a href="#first"><span class="contents-number">1</span><span class="contents-text">Thing</span></a>'
    assert_equal expected, wrap_numbers_with_spans(input)
  end

  test "it wraps a number in the form X.Y" do
    input = '<a href="#vision">1.2 Vision</a>'
    expected = '<a href="#vision"><span class="contents-number">1.2</span><span class="contents-text">Vision</span></a>'
    assert_equal expected, wrap_numbers_with_spans(input)
  end

  test "it does nothing if no number is found" do
    input = '<a href="#vision">Vision</a>'
    expected = '<a href="#vision">Vision</a>'
    assert_equal expected, wrap_numbers_with_spans(input)
  end

  test "it does nothing if it's just a number" do
    input = '<a href="#first">1</a>'
    expected = '<a href="#first">1</a>'
    assert_equal expected, wrap_numbers_with_spans(input)
  end

  test "it does nothing if the number is part of the word" do
    input = '<a href="#vision">1Vision</a>'
    expected = '<a href="#vision">1Vision</a>'
    assert_equal expected, wrap_numbers_with_spans(input)

    input = '<a href="#vision">1.Vision</a>'
    expected = '<a href="#vision">1.Vision</a>'
    assert_equal expected, wrap_numbers_with_spans(input)
  end

  test "it does nothing if it starts with a number longer than 3 digits" do
    input = '<a href="#vision">2014 Vision</a>'
    expected = '<a href="#vision">2014 Vision</a>'
    assert_equal expected, wrap_numbers_with_spans(input)

    input = '<a href="#vision">2014. Vision</a>'
    expected = '<a href="#vision">2014. Vision</a>'
    assert_equal expected, wrap_numbers_with_spans(input)

    input = '<a href="#vision">10001. Vision</a>'
    expected = '<a href="#vision">10001. Vision</a>'
    assert_equal expected, wrap_numbers_with_spans(input)
  end

  test "it does nothing if a number is present but not at the start" do
    input = '<a href="#run-an-effective-welfare-system">Run an effective welfare system part 1. Social Care</a>'
    expected = '<a href="#run-an-effective-welfare-system">Run an effective welfare system part 1. Social Care</a>'
    assert_equal expected, wrap_numbers_with_spans(input)
  end
end
