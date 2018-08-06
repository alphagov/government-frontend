require 'test_helper'

class LinksOutTest < ActiveSupport::TestCase
  def setup
    @links_out = Object.new
    @links_out.extend(ContentItem::LinksOut)
    class << @links_out
      def content_item
        {
            "content_purpose_supergroup" => "guidance_and_regulation",
            "content_purpose_subgroup" => "guidance",
            "document_type" => "guide"
        }
      end
    end
  end

  def rules
    {
        "content_purpose_supergroup" => { "guidance_and_regulation" => %w(link_to_guidance_and_regulation) },
        "content_purpose_subgroup" => { "guidance" => %w(link_to_guidance) },
        "document_type" => { "guide" => %w(link_to_guide) }
    }
  end

  def other_rules
    {
        "content_purpose_supergroup" => { "news_and_communication" => %w(link_to_news_and_communication) },
        "content_purpose_subgroup" => { "news" => %w(link_to_news) },
        "document_type" => { "article" => %w(link_to_article) }
    }
  end

  def stub_load_rules(rules)
    ContentItem::LinksOut::LinkRule.any_instance.stubs(:load_rules).returns(rules)
  end

  def assert_has_supergroup_rule(rule_set)
    assert rule_set["content_purpose_supergroup"].has_key?("guidance_and_regulation")
  end

  def assert_has_subgroup_rule(rule_set)
    assert rule_set["content_purpose_subgroup"].has_key?("guidance")
  end

  def assert_has_document_type_rule(rule_set)
    assert rule_set["document_type"].has_key?("guide")
  end

  test 'returns empty array if the content_item is blank' do
    class << @links_out
      def content_item
        {}
      end
    end

    assert_equal [], @links_out.links_out
  end

  test 'returns empty array if the link rules is blank' do
    stub_load_rules({})

    assert_equal [], @links_out.links_out
  end

  test 'returns empty array if the link does not contain any rules for this content_item' do
    stub_load_rules(other_rules)

    assert_equal [], @links_out.links_out
  end

  test 'returns document type rule if it is defined within rule set' do
    assert_has_supergroup_rule(rules)
    assert_has_subgroup_rule(rules)
    stub_load_rules(rules)
    assert_equal %w(link_to_guide), @links_out.links_out
  end

  test 'returns subgroup rule if it is defined within rule set and document_type is not' do
    amended_rules = rules
    amended_rules["document_type"] = nil
    assert_has_supergroup_rule(amended_rules)
    assert_has_subgroup_rule(amended_rules)
    stub_load_rules(amended_rules)
    assert_equal %w(link_to_guidance), @links_out.links_out
  end

  test 'returns supergroup rule if it is defined within rule set, document_type and supergroup are not' do
    amended_rules = rules
    amended_rules["content_purpose_subgroup"] = nil
    amended_rules["document_type"] = nil
    assert_has_supergroup_rule(amended_rules)
    stub_load_rules(amended_rules)
    assert_equal %w(link_to_guidance_and_regulation), @links_out.links_out
  end

  test 'returns subgroup rule if it is defined within rule set and document_type does not match' do
    amended_rules = rules
    amended_rules["document_type"] = other_rules["document_type"]
    assert_has_supergroup_rule(amended_rules)
    assert_has_subgroup_rule(amended_rules)
    stub_load_rules(amended_rules)
    assert_equal %w(link_to_guidance), @links_out.links_out
  end

  test 'returns supergroup rule if it is defined within rule set, document_type and supergroup do not match' do
    amended_rules = rules
    amended_rules["content_purpose_subgroup"] = other_rules["content_purpose_subgroup"]
    amended_rules["document_type"] = other_rules["document_type"]
    assert_has_supergroup_rule(amended_rules)
    stub_load_rules(amended_rules)
    assert_equal %w(link_to_guidance_and_regulation), @links_out.links_out
  end

  test 'returns nothing if the document type is an empty array' do
    amended_rules = rules
    amended_rules["document_type"] = { "guide" => [] }
    assert_has_supergroup_rule(amended_rules)
    assert_has_subgroup_rule(amended_rules)
    stub_load_rules(amended_rules)
    assert_equal [], @links_out.links_out
  end
end
