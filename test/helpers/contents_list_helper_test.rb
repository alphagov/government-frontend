require 'test_helper'

class ContentsListHelperTest < ActionView::TestCase
  test "it wraps the number and text in span elements" do
    input = '<a data-track-category="contentsClicked" data-track-action="leftColumnH2" data-track-label="run-an-effective-welfare-system-that-enables-people-to-achieve-financial-independence-by-providing-assistance-and-guidance-into-employment" href="#run-an-effective-welfare-system-that-enables-people-to-achieve-financial-independence-by-providing-assistance-and-guidance-into-employment">1. Run an effective welfare system that enables people to achieve financial independence by providing assistance and guidance into employment</a>'
    expected = '<a data-track-category="contentsClicked" data-track-action="leftColumnH2" data-track-label="run-an-effective-welfare-system-that-enables-people-to-achieve-financial-independence-by-providing-assistance-and-guidance-into-employment" href="#run-an-effective-welfare-system-that-enables-people-to-achieve-financial-independence-by-providing-assistance-and-guidance-into-employment"><span class="contents-number">1.</span><span class="contents-text">Run an effective welfare system that enables people to achieve financial independence by providing assistance and guidance into employment</span></a>'
    assert_equal expected, insert_spans(input)
  end

  test "it does nothing if no number is found" do
    input = '<a data-track-category="contentsClicked" data-track-action="leftColumnH2" data-track-label="vision" href="#vision">Vision</a>'
    expected = '<a data-track-category="contentsClicked" data-track-action="leftColumnH2" data-track-label="vision" href="#vision">Vision</a>'
    assert_equal expected, insert_spans(input)
  end

  test "it does nothing if a number is present but not at the start" do
    input = '<a href="#run-an-effective-welfare-system">Run an effective welfare system part 1. Social Care</a>'
    expected = '<a href="#run-an-effective-welfare-system">Run an effective welfare system part 1. Social Care</a>'
    assert_equal expected, insert_spans(input)
  end
end
