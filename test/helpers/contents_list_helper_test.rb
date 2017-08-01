require 'test_helper'

class ContentsListHelperTest < ActionView::TestCase
  test "it wraps a number and text in separate span elements" do
    assert_split_number_and_text('1. Thing', '1.', 'Thing')
    assert_split_number_and_text('10. Thing', '10.', 'Thing')
    assert_split_number_and_text('100. Thing', '100.', 'Thing')
  end

  test "it wraps a number and text in span elements if it's a number without a period" do
    assert_split_number_and_text('1 Thing', '1', 'Thing')
  end

  test "it wraps a number in the form X.Y" do
    assert_split_number_and_text('1.2 Vision', '1.2', 'Vision')
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

  def assert_split_number_and_text(number_and_text, number, text)
    number_class = "app-c-contents-list__number"
    numbered_text_class = "app-c-contents-list__numbered-text"

    input = "<a href=\"#link\">#{number_and_text}</a>"
    expected = "<a href=\"#link\"><span class=\"#{number_class}\">#{number}</span><span class=\"#{numbered_text_class}\">#{text}</span></a>"
    assert_equal expected, wrap_numbers_with_spans(input)
  end
end
