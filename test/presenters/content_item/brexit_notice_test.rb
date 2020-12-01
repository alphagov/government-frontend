require "test_helper"

class ContentItemBrexitNoticeTest < ActiveSupport::TestCase
  class DummyContentItem
    attr_reader :content_item
    def initialize(details_hash)
      @content_item = { "content_id" => "123abc", "details" => details_hash }
    end
  end

  class DummyContentItemPresenter
    include ContentItem::BrexitNotice

    attr_reader :content_item, :view_context

    def initialize(content_item, view_context)
      @content_item = content_item
      @view_context = view_context
    end
  end

  test "no content notices are present in the content item" do
    content_item = DummyContentItem.new({}).content_item
    view_context = ApplicationController.new.view_context
    presenter = DummyContentItemPresenter.new(content_item, view_context)
    assert_equal presenter.has_no_deal_notice?, false
    assert_equal presenter.has_current_state_notice?, false
    assert_equal presenter.brexit_notice_component, nil
  end

  test "brexit_no_deal_notice is present in the content item" do
    no_deal_details_hash = {
      "brexit_no_deal_notice" => [
        {
          "href" => "/blah",
          "title" => "Blah",
        },
      ],
    }
    expected_hash = {
      title: "New rules for January 2021",
      links: [
        {
          title: "Blah",
          href: "/blah",
          data_attributes: {
            "module": "track-click",
            "track-category": "no_deal_notice",
            "track-action": "/blah",
            "track-label": "Blah",
          },
        },
      ],
    }
    content_item = DummyContentItem.new(no_deal_details_hash).content_item
    view_context = ApplicationController.new.view_context
    presenter = DummyContentItemPresenter.new(content_item, view_context)

    assert_equal presenter.has_no_deal_notice?, true
    assert_equal presenter.has_current_state_notice?, false

    expected_hash.keys.each do |key|
      assert_equal presenter.brexit_notice_component[key], expected_hash[key]
    end
  end

  test "brexit_current_state_notice is present in the content item" do
    current_state_details_hash = {
      "brexit_current_state_notice" => [
        {
          "href" => "/blah",
          "title" => "Blah",
        },
      ],
    }
    expected_hash = {
      title: "Brexit transition: new rules for 2021",
      links: [
        {
          title: "Blah",
          href: "/blah",
          data_attributes: {
            "module": "track-click",
            "track-category": "current_state_notice",
            "track-action": "/blah",
            "track-label": "Blah",
          },
        },
      ],
    }
    content_item = DummyContentItem.new(current_state_details_hash).content_item
    view_context = ApplicationController.new.view_context
    presenter = DummyContentItemPresenter.new(content_item, view_context)

    assert_equal presenter.has_no_deal_notice?, false
    assert_equal presenter.has_current_state_notice?, true

    expected_hash.keys.each do |key|
      assert_equal presenter.brexit_notice_component[key], expected_hash[key]
    end
  end

  test "featured_link without any links in the current_state notice" do
    details_hash = { "brexit_current_state_notice" => [] }
    content_item = DummyContentItem.new(details_hash).content_item
    view_context = ApplicationController.new.view_context
    component = DummyContentItemPresenter.new(content_item, view_context).brexit_notice_component

    assert component[:featured_link].include?("Check what else you need to do during")
    assert_not component[:featured_link].include?("You can also read about")
    assert component[:featured_link].include?('data-track-category="current_state_notice"')
    assert_not component[:featured_link].include?('data-track-category="no_deal_notice"')
  end

  test "featured_link with links in the current_state notice" do
    details_hash = { "brexit_current_state_notice" => [{ "href" => "/blah", "title" => "Blah" }] }
    content_item = DummyContentItem.new(details_hash).content_item
    view_context = ApplicationController.new.view_context
    component = DummyContentItemPresenter.new(content_item, view_context).brexit_notice_component

    assert component[:featured_link].include?("You can also read about")
    assert_not component[:featured_link].include?("Check what else you need to do during")
  end

  test "featured_link without any links in the no_deal notice" do
    details_hash = { "brexit_no_deal_notice" => [] }
    content_item = DummyContentItem.new(details_hash).content_item
    view_context = ApplicationController.new.view_context
    component = DummyContentItemPresenter.new(content_item, view_context).brexit_notice_component

    assert component[:featured_link].include?('data-track-category="no_deal_notice"')
    assert_not component[:featured_link].include?('data-track-category="current_state_notice"')
  end
end
