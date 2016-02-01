require 'test_helper'

class TypographyHelperTest < ActionView::TestCase
  test "nbsp_between_last_two_words" do
    assert_equal "this", nbsp_between_last_two_words("this")
    assert_equal "this and&nbsp;that", nbsp_between_last_two_words("this and that")
    assert_equal "this and&nbsp;that.", nbsp_between_last_two_words("this and that.")
    assert_equal "this and&nbsp;that\n\n", nbsp_between_last_two_words("this and that\n\n")
    assert_equal "multiline\nthis and&nbsp;that", nbsp_between_last_two_words("multiline\nthis and that")

    assert_equal "NCS is for 16 and 17 year&nbsp;olds.", nbsp_between_last_two_words("NCS is for 16 and 17 year olds.")
  end
end
