require 'test_helper'

class ContentsListTest < ActiveSupport::TestCase
  def setup
    @contents_list = Object.new
    @contents_list.extend(ContentsList)
  end

  test "memoises the contents to avoid repeated processing and extraction" do
    class << @contents_list
      def body
        '<h2 id="custom">A heading</h2>'
      end
    end

    @contents_list.expects(:contents_items).returns([{ text: "A heading", id: 'custom' }]).once
    @contents_list.contents
    @contents_list.contents
  end

  test "extracts a single h2" do
    class << @contents_list
      def body
        '<h2 id="custom">A heading</h2>'
      end
    end

    assert_equal [{ text: "A heading", id: 'custom' }], @contents_list.contents_items
  end

  test "removes trailing colons from headings" do
    class << @contents_list
      def body
        '<h2 id="custom">List:</h2>'
      end
    end

    assert_equal [{ text: "List", id: 'custom' }], @contents_list.contents_items
  end

  test "removes only trailing colons from headings" do
    class << @contents_list
      def body
        '<h2 id="custom">Part 2: List:</h2>'
      end
    end

    assert_equal [{ text: "Part 2: List", id: 'custom' }], @contents_list.contents_items
  end

  test "ignores headings without an id" do
    class << @contents_list
      def body
        '<h2>John Doe</h2>'
      end
    end

    assert_empty @contents_list.contents_items
  end

  test "extracts multiple h2s" do
    class << @contents_list
      def body
        '<h2 id="one">One</h2>
         <p>One is the loneliest number</p>
         <h2 id="two">Two</h2>
         <p>Two can be as bad as one</p>
         <h2 id="three">Three</h2>
         <h3>Pi</h3>
         <h2 id="four">Four</h2>'
      end
    end

    assert_equal [
      { text: "One", id: "one" },
      { text: "Two", id: "two" },
      { text: "Three", id: "three" },
      { text: "Four", id: "four" }], @contents_list.contents_items
  end
end
