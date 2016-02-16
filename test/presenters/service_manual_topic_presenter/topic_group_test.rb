require 'test_helper'

class ServiceManualTopicPresenter::TopicGroupTest < ActiveSupport::TestCase
  def described_class
    ServiceManualTopicPresenter::TopicGroup
  end

  def group_data
    {
       "name" => "Fruits",
       "description" => "Nice fruits",
       "content_ids" => %w(111 222)
     }
  end

  test 'pertains order in the groups hash' do
    linked_items = [
                     { "content_id" => "222", "title" => "Bananas" },
                     { "content_id" => "111", "title" => "Apples" }
                   ]
    group = described_class.new(group_data, linked_items)

    assert_equal %w(Apples Bananas), group.linked_items.map(&:label)
  end

  test 'omits grouped but unpublished linked items (not in the links hash)' do
    linked_items = [{ "content_id" => "222", "title" => "Bananas" }]
    group = described_class.new(group_data, linked_items)

    assert_equal ["Bananas"], group.linked_items.map(&:label)
  end

  test 'present? returns true if there are no visible grouped links' do
    linked_items = [{ "content_id" => "222", "title" => "Bananas" }]
    group = described_class.new(group_data, linked_items)

    assert group.present?
  end

  test 'present? returns false if there are no visible grouped links' do
    linked_items = []
    group = described_class.new(group_data, linked_items)

    refute group.present?
  end
end
