require 'test_helper'

module ContentItemPartsStubs
  def base_path
    '/base-path'
  end

  def content_item
    {
      'details' => {
        'parts' => [
          {
            'title' => 'first-title',
            'slug' => 'first-slug',
            'body' => 'first-body',
          },
          {
            'title' => 'second-title',
            'slug' => 'second-slug',
            'body' => 'second-body',
          }
        ]
      }
    }
  end
end

module PresentingFirstPartInContentItem
  def part_slug
    nil
  end

  def requested_content_item_path
    base_path
  end
end

module PresentingSecondPartInContentItem
  def part_slug
    'second-slug'
  end

  def requested_content_item_path
    base_path
  end
end

class ContentItemPartsTest < ActiveSupport::TestCase
  def setup
    @parts = Object.new
    @parts.extend(ContentItem::Parts)
    @parts.extend(ContentItemPartsStubs)
  end

  def presenting_first_part_in_content_item
    @parts.extend(PresentingFirstPartInContentItem)
  end

  def presenting_second_part_in_content_item
    @parts.extend(PresentingSecondPartInContentItem)
  end

  test 'is not requesting a part when no parts exist' do
    class << @parts
      def content_item
        { 'details' => {} }
      end
    end

    refute @parts.requesting_a_part?
  end

  test 'is not requesting a part when parts exist and base_path matches requested_content_item_path' do
    class << @parts
      def requested_content_item_path
        base_path
      end
    end

    refute @parts.requesting_a_part?
  end

  test 'is requesting a part when part exists and base_path is different to requested_content_item_path' do
    class << @parts
      def part_slug
        'second-slug'
      end

      def requested_content_item_path
        base_path + '/second-slug'
      end
    end

    assert @parts.requesting_a_part?
  end

  test 'is requesting a valid part when part exists' do
    class << @parts
      def part_slug
        'second-slug'
      end

      def requested_content_item_path
        base_path + '/' + part_slug
      end
    end

    assert @parts.has_valid_part?
    assert_equal @parts.current_part_body, 'second-body'
    assert_equal @parts.current_part_title, 'second-title'
  end

  test 'is requesting an invalid part when no part with corresponding slug exists' do
    class << @parts
      def part_slug
        'not-a-valid-slug'
      end

      def requested_content_item_path
        base_path + '/' + part_slug
      end
    end

    assert @parts.requesting_a_part?
    refute @parts.has_valid_part?
  end

  test 'invalid when slug for first part is present in URL' do
    class << @parts
      def part_slug
        'first-slug'
      end

      def requested_content_item_path
        base_path + '/' + part_slug
      end
    end

    assert @parts.requesting_a_part?
    refute @parts.has_valid_part?
  end

  test 'defaults to first part as current part when parts exist but no part requested' do
    presenting_first_part_in_content_item

    refute @parts.requesting_a_part?
    assert_equal @parts.current_part_body, 'first-body'
    assert_equal @parts.current_part_title, 'first-title'
  end

  test 'navigation items are presented as trackable links unless they are the current part' do
    presenting_first_part_in_content_item
    assert_equal @parts.current_part_title, 'first-title'
    assert_equal @parts.parts_navigation,
      [[
        "first-title",
        "<a class=\"govuk-link\" data-track-category=\"contentsClicked\" data-track-action=\"content_item 2\" "\
        "data-track-label=\"/base-path/second-slug\" "\
        "data-track-options=\"{&quot;dimension29&quot;:&quot;second-title&quot;}\" "\
        "href=\"/base-path/second-slug\">second-title</a>"
      ]]
  end

  test 'links to the first part ignore the part\'s slug and use the base path' do
    presenting_second_part_in_content_item
    assert_equal @parts.current_part_title, 'second-title'
    assert @parts.parts_navigation[0][0].include? "href=\"/base-path\""
  end

  test 'navigation items link to all parts' do
    presenting_first_part_in_content_item
    assert_equal @parts.parts.size, @parts.parts_navigation.flatten.size
  end

  test 'part navigation is in one group when 3 or fewer navigation items (2 parts + summary)' do
    presenting_first_part_in_content_item

    class << @parts
      def content_item
        {
          'details' => {
            'parts' => [
              { 'title' => 'title', 'slug' => 'slug', 'body' => 'body' },
              { 'title' => 'title', 'slug' => 'slug', 'body' => 'body' },
              { 'title' => 'title', 'slug' => 'slug', 'body' => 'body' }
            ]
          }
        }
      end
    end

    assert_equal 1, @parts.parts_navigation.size
  end

  test "part navigation is split into two equal groups when more than 3 items" do
    presenting_first_part_in_content_item

    class << @parts
      def content_item
        {
          'details' => {
            'parts' => [
              { 'title' => 'first-title', 'slug' => 'first-slug', 'body' => 'first-body' },
              { 'title' => 'second-title', 'slug' => 'second-slug', 'body' => 'second-body' },
              { 'title' => 'third-title', 'slug' => 'third-slug', 'body' => 'third-body' },
              { 'title' => 'fourth-title', 'slug' => 'fourth-slug', 'body' => 'fourth-body' }
            ]
          }
        }
      end
    end

    assert_equal @parts.parts_navigation, [
        [
          "first-title", "<a class=\"govuk-link\" data-track-category=\"contentsClicked\" "\
          "data-track-action=\"content_item 2\" data-track-label=\"/base-path/second-slug\" "\
          "data-track-options=\"{&quot;dimension29&quot;:&quot;second-title&quot;}\" "\
          "href=\"/base-path/second-slug\">second-title</a>"
        ],
        [
          "<a class=\"govuk-link\" data-track-category=\"contentsClicked\" data-track-action=\"content_item 3\" "\
          "data-track-label=\"/base-path/third-slug\" "\
          "data-track-options=\"{&quot;dimension29&quot;:&quot;third-title&quot;}\" "\
          "href=\"/base-path/third-slug\">third-title</a>",
          "<a class=\"govuk-link\" data-track-category=\"contentsClicked\" data-track-action=\"content_item 4\" "\
          "data-track-label=\"/base-path/fourth-slug\" "\
          "data-track-options=\"{&quot;dimension29&quot;:&quot;fourth-title&quot;}\" "\
          "href=\"/base-path/fourth-slug\">fourth-title</a>"
        ]
      ]
  end
end
