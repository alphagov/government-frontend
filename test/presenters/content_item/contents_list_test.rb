require "test_helper"

class ContentItemContentsListTest < ActiveSupport::TestCase
  def setup
    @contents_list = Object.new
    @contents_list.extend(ContentItem::ContentsList)
  end

  test "memoises the contents to avoid repeated processing and extraction" do
    class << @contents_list
      def body
        '<h2 id="custom">A heading</h2>'
      end
    end

    @contents_list.expects(:contents_items).returns([{ text: "A heading", id: "custom" }]).once
    @contents_list.contents
    @contents_list.contents
  end

  test "extracts a single h2" do
    class << @contents_list
      def body
        '<h2 id="custom">A heading</h2>'
      end
    end

    assert_equal [{ text: "A heading", id: "custom" }], @contents_list.contents_items
  end

  test "removes trailing colons from headings" do
    class << @contents_list
      def body
        '<h2 id="custom">List:</h2>'
      end
    end

    assert_equal [{ text: "List", id: "custom" }], @contents_list.contents_items
  end

  test "removes only trailing colons from headings" do
    class << @contents_list
      def body
        '<h2 id="custom">Part 2: List:</h2>'
      end
    end

    assert_equal [{ text: "Part 2: List", id: "custom" }], @contents_list.contents_items
  end

  test "ignores headings without an id" do
    class << @contents_list
      def body
        "<h2>John Doe</h2>"
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
      { text: "Four", id: "four" },
    ], @contents_list.contents_items
  end

  test "#show_contents_list? returns true if number of contents items is less than 3 and the first item's character count is above 415" do
    class << @contents_list
      def body
        "<h2 id='one'>One</h2>
         <p>#{Faker::Lorem.characters(number: 220)}</p>
         <p>#{Faker::Lorem.characters(number: 196)}</p>
         <h2 id='two'>Two</h2>
         <p>#{Faker::Lorem.sentence}</p>"
      end
    end
    assert @contents_list.show_contents_list?
  end

  test "#show_contents_list? returns true if number of contents items is 2 and the first item's character count is above 415 including a list" do
    class << @contents_list
      def body
        "<h2 id='one'>One</h2>
         <p>#{Faker::Lorem.characters(number: 40)}</p>
         <ul>
          <li>#{Faker::Lorem.characters(number: 100)}</li>
          <li>#{Faker::Lorem.characters(number: 100)}</li>
          <li>#{Faker::Lorem.characters(number: 200)}</li>
         </ul>
         <p>#{Faker::Lorem.characters(number: 40)}</p>
         <h2 id='two'>Two</h2>
         <p>#{Faker::Lorem.sentence}</p>"
      end
    end
    assert @contents_list.show_contents_list?
  end

  test "#show_contents_list? returns true if number of contents items is 3 or more" do
    class << @contents_list
      def body
        "<h2 id='one'>One</h2>
         <p>#{Faker::Lorem.sentence}</p>
         <h2 id='two'>Two</h2>
         <p>#{Faker::Lorem.sentence}</p>
         <h2 id='three'>Three</h2>
         <h3>Pi</h3>
         <h2 id='four'>#{Faker::Lorem.sentence}</h2>"
      end
    end
    assert @contents_list.show_contents_list?
  end

  test "#show_contents_list? returns false if number of contents times is less than 3 and first item's character count is less than 415" do
    class << @contents_list
      def body
        "<h2 id='one'>One</h2>
         <p>#{Faker::Lorem.characters(number: 10)}</p>
         <p>#{Faker::Lorem.characters(number: 10)}</p>
         <h2 id='two'>Two</h2>
         <p>#{Faker::Lorem.sentence}</p>"
      end
    end
    assert_not @contents_list.show_contents_list?
  end

  test "#show_contents_list? returns true if number of table rows in the first item is more than 13" do
    class << @contents_list
      def body
        base = "<h2 id='one'>One</h2><table>\n<tbody>\n"
        14.times do
          base += "<tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n"
        end
        base += "</tbody>\n</table><h2 id='two'>Two</h2>"
      end
    end
    assert @contents_list.show_contents_list?
  end

  test "#show_contents_list? returns false if number of table rows in the first item is less than 13" do
    class << @contents_list
      def body
        "<h2 id='one'>One</h2><table>\n<tbody>\n
        <tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n
        <tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n
        </tbody>\n</table><h2 id='two'>Two</h2>"
      end
    end
    assert_not @contents_list.show_contents_list?
  end

  test "#show_contents_list? returns true if image and over 224 characters are present in the first item" do
    class << @contents_list
      def body
        "<h2 id='one'>One</h2>
        <div class='img'><img src='www.gov.uk/img.png'></div>
        <p>#{Faker::Lorem.characters(number: 225)}</p>
        <h2 id='two'>Two</h2>
        <p>#{Faker::Lorem.sentence}</p>"
      end
    end
    assert @contents_list.show_contents_list?
  end

  test "#show_contents_list? returns true if image and table over 6 rows are present in the first item" do
    class << @contents_list
      def body
        base = "<h2 id='one'>One</h2><div class='img'>
          <img src='www.gov.uk/img.png'></div><table>\n<tbody>\n"
        7.times do
          base += "<tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n"
        end
        base += "</tbody>\n</table><h2 id='two'>Two</h2>"
      end
    end
    assert @contents_list.show_contents_list?
  end

  test "#show_contents_list? returns true if body is over 415 characters and has no h2s present" do
    class << @contents_list
      def body
        "<div><p>#{Faker::Lorem.characters(number: 416)}</p></div>"
      end
    end
    @contents_list.stubs(:contents_items).returns(["item 1", "item2"])
    @contents_list.stubs(:first_item).returns(first_element)
    assert @contents_list.show_contents_list?
  end

  def first_element
    Nokogiri::HTML(@contents_list.body).css("div").first.first_element_child
  end
end
