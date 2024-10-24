require "test_helper"

class ContentItemContentsListTest < ActiveSupport::TestCase
  def setup
    content_item = { "title" => "thing" }
    @contents_list = Object.new
    @contents_list.stubs(:content_item).returns(content_item)
    @contents_list.stubs(:view_context)
                  .returns(ApplicationController.new.view_context)
    @contents_list.extend(ContentItem::ContentsList)
  end

  test "memoises the contents to avoid repeated processing and extraction" do
    class << @contents_list
      def body
        '<h2 id="custom">A heading</h2>'
      end
    end

    @contents_list.expects(:show_contents_list?).returns(true).once
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
    ],
                 @contents_list.contents_items
  end

  test "displays content list if there is an H2" do
    class << @contents_list
      def body
        "<h2 id='one'>One</h2>"
      end
    end
    assert @contents_list.show_contents_list?
  end

  test "displays no contents list if there is no H2 and first item is less than 415" do
    class << @contents_list
      def body
        "<div>
          <p>#{Faker::Lorem.characters(number: 400)}</p>
        </div>
        "
      end
    end
    assert_not @contents_list.show_contents_list?
  end

  test "displays contents list if the first item's character count is above 415, including a list" do
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

  test "does not display contents list if the first item's character count is less than 415" do
    class << @contents_list
      def body
        "<p>#{Faker::Lorem.characters(number: 20)}</p>
         <p>#{Faker::Lorem.characters(number: 20)}</p>
         <p>#{Faker::Lorem.sentence}</p>"
      end
    end
    assert_not @contents_list.show_contents_list?
  end

  test "displays contents list if number of table rows in the first item is more than 13" do
    class << @contents_list
      def body
        base = "<h2 id='one'>One</h2><table>\n<tbody>\n"
        14.times do
          base += "<tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}</td>\n</tr>\n"
        end
        base += "</tbody>\n</table><h2 id='two'>Two</h2>"
      end
    end
    assert @contents_list.show_contents_list?
  end

  test "does not display contents list if number of table rows in the first item is less than 13" do
    class << @contents_list
      def body
        "<table>\n<tbody>\n
        <tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n
        <tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n
        </tbody>\n</table>"
      end
    end
    assert_not @contents_list.show_contents_list?
  end

  test "displays contents list if image is present and the first_item's character count is over 224" do
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

  test "displays contents list if an image and a table with more than 6 rows are present in the first item" do
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

  def first_element
    Nokogiri::HTML(@contents_list.body).css("div").first.first_element_child
  end
end
