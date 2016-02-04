require 'test_helper'

class TypographyHelperTest < ActionView::TestCase
  include ERB::Util

  test "nbsp_between_last_two_words" do
    assert_equal "this and&nbsp;that", nbsp_between_last_two_words("this and that")
    assert_equal "this and&nbsp;that", nbsp_between_last_two_words("this and that ")
    assert_equal "this and&nbsp;that.", nbsp_between_last_two_words("this and that.")
    assert_equal "this and&nbsp;that.", nbsp_between_last_two_words("this and that. ")
    assert_equal "this and&nbsp;that", nbsp_between_last_two_words("this and that\n\n")
    assert_equal "multiline\nthis and&nbsp;that", nbsp_between_last_two_words("multiline\nthis and that")
    assert_equal "NCS is for 16 and 17 year&nbsp;olds.", nbsp_between_last_two_words("NCS is for 16 and 17 year olds.")
  end

  test "nbsp_between_last_two_words leaves alone single words" do
    assert_equal "this", nbsp_between_last_two_words("this")
  end

  test "nbsp_between_last_two_words isn't unsafe" do
    assert_equal "&lt;b&gt;this&lt;b&gt; &amp; that&nbsp;thing", nbsp_between_last_two_words("<b>this<b> & that thing")
    assert_equal "&lt;b&gt;this&lt;b&gt; &amp;&nbsp;that", nbsp_between_last_two_words("<b>this<b> &amp; that")
  end
end
