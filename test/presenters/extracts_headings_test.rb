require 'test_helper'

class ExtractsHeadingsTest < ActiveSupport::TestCase
  include ExtractsHeadings

  test "extracts a single h2" do
    html = '<h2 id="custom">A heading</h2>'
    assert_equal [{text: "A heading", id: 'custom'}], extract_headings_with_ids(html)
  end

  test "ignores headings without an id" do
    html = '<h2>John Doe</h2>'
    assert_empty extract_headings_with_ids(html)
  end

  test "extracts multiple h2s" do
    html = '<h2 id="one">One</h2>
            <p>One is the loneliest number</p>
            <h2 id="two">Two</h2>
            <p>Two can be as bad as one</p>
            <h2 id="three">Three</h2>
            <h3>Pi</h3>
            <h2 id="four">Four</h2>'
    assert_equal [
      {text: "One", id: "one"},
      {text: "Two", id: "two"},
      {text: "Three", id: "three"},
      {text: "Four", id: "four"}], extract_headings_with_ids(html)
  end
end
