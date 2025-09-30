require "test_helper"

class Sanitiser::StrategyTest < ActiveSupport::TestCase
  test "should pass a valid string" do
    assert_nil Sanitiser::Strategy.call("hello")
  end

  test "should raise an exception if non-UTF-8 chars are in the string" do
    assert_raise(Sanitiser::Strategy::SanitisingError) { Sanitiser::Strategy.call("he\xC2llo") }
  end
end
