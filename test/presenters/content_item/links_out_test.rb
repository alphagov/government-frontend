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
        "content_purpose_supergroup" => {
            "guidance_and_regulation" => [
                {
                    "title" => "link_to_guidance_and_regulation",
                    "type" => "content_purpose_supergroup",
                    "supergroup" => "services"
                }
            ]
        },
        "content_purpose_subgroup" => {
            "guidance" => [
                {
                    "title" => "link_to_guidance",
                    "type" => "content_purpose_subgroup",
                    "supergroup" => "transparency"
                }
            ]
        },
        "document_type" => {
            "guide" => [
                {
                    "title" => "link_to_guide",
                    "type" => "document_type",
                    "supergroup" => "guidance_and_regulation"
                }
            ]
        }
    }
  end

  def other_rules
    {
        "content_purpose_supergroup" => {
            "news_and_communications" => [
                {
                    "title" => "link_to_news_and_communications",
                    "type" => "content_purpose_supergroup",
                    "supergroup" => "news_and_communications"
                }
            ]
        },
        "content_purpose_subgroup" => {
            "news" => [
                {
                    "title" => "link_to_news",
                    "type" => "content_purpose_subgroup",
                    "supergroup" => "news_and_communications"
                }
            ]
        },
        "document_type" => {
            "article" => [
                {
                    "title" => "link_to_article",
                    "type" => "document_type",
                    "supergroup" => "news_and_communications"
                }
            ]
        }
    }
  end

  def stub_load_rules(rules)
    Rails.configuration.taxonomy_navigation_links_out = rules
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

  def assert_returns_guide
    assert_equal [{ "title" => "link_to_guide", "type" => "document_type", "supergroup" => "guidance_and_regulation" }], @links_out.links_out
  end

  def assert_returns_guidance
    assert_equal %w(guidance), @links_out.links_out_subgroups("guidance_and_regulation")
  end

  def assert_returns_guidance_and_regulation
    assert_equal %w(guidance_and_regulation), @links_out.links_out_supergroups
  end

  def news_and_communications_rule
    { "title" => "link_to_news_and_communications", "type" => "content_purpose_supergroup", "supergroup" => "news_and_communications" }
  end

  def news_rule
    { "title" => "link_to_news", "type" => "content_purpose_subgroup", "supergroup" => "news_and_communications" }
  end

  test 'links_out_supergroups returns empty array if the content_item is blank' do
    class << @links_out
      def content_item
        {}
      end
    end
    assert_equal [], @links_out.links_out_supergroups
  end

  test 'links_out_supergroups returns empty array if the link rules is blank' do
    stub_load_rules({})
    assert_equal [], @links_out.links_out_supergroups
  end

  test 'links_out_supergroups returns empty array if the link does not contain any rules for this content_item' do
    stub_load_rules(other_rules)
    assert_equal [], @links_out.links_out_supergroups
  end

  test 'links_out_supergroups returns document type rule if it is defined within rule set' do
    assert_has_supergroup_rule(rules)
    assert_has_subgroup_rule(rules)
    assert_has_document_type_rule(rules)
    stub_load_rules(rules)
    assert_equal %w(guidance_and_regulation), @links_out.links_out_supergroups
  end

  test 'links_out_supergroups returns subgroup rule if it is defined within rule set and document_type is not' do
    amended_rules = rules
    amended_rules["document_type"] = nil
    assert_has_supergroup_rule(amended_rules)
    assert_has_subgroup_rule(amended_rules)
    stub_load_rules(amended_rules)
    assert_equal %w(transparency), @links_out.links_out_supergroups
  end

  test 'links_out_supergroups returns supergroup rule if it is defined within rule set, document_type and supergroup are not' do
    amended_rules = rules
    amended_rules["content_purpose_subgroup"] = nil
    amended_rules["document_type"] = nil
    assert_has_supergroup_rule(amended_rules)
    stub_load_rules(amended_rules)
    assert_equal %w(services), @links_out.links_out_supergroups
  end

  test 'links_out_supergroups returns subgroup rule if it is defined within rule set and document_type does not match' do
    amended_rules = rules
    amended_rules["document_type"] = other_rules["document_type"]
    assert_has_supergroup_rule(amended_rules)
    assert_has_subgroup_rule(amended_rules)
    stub_load_rules(amended_rules)
    assert_equal %w(transparency), @links_out.links_out_supergroups
  end

  test 'links_out_supergroups returns supergroup rule if it is defined within rule set, document_type and supergroup do not match' do
    amended_rules = rules
    amended_rules["content_purpose_subgroup"] = other_rules["content_purpose_subgroup"]
    amended_rules["document_type"] = other_rules["document_type"]
    assert_has_supergroup_rule(amended_rules)
    stub_load_rules(amended_rules)
    assert_equal %w(services), @links_out.links_out_supergroups
  end

  test 'links_out_supergroups returns nothing if the document type is an empty array' do
    amended_rules = rules
    amended_rules["document_type"] = { "guide" => [] }
    assert_has_supergroup_rule(amended_rules)
    assert_has_subgroup_rule(amended_rules)
    stub_load_rules(amended_rules)
    assert_equal [], @links_out.links_out_supergroups
  end

  test 'links_out_supergroups returns correct supergroup names for content_purpose_supergroup rules' do
    amended_rules = rules
    amended_rules["content_purpose_supergroup"]["guidance_and_regulation"] << news_and_communications_rule
    amended_rules["content_purpose_subgroup"] = nil
    amended_rules["document_type"] = nil

    stub_load_rules(amended_rules)
    assert_equal %w(services news_and_communications), @links_out.links_out_supergroups
  end

  test 'links_out_supergroups returns correct supergroup names for content_purpose_subgroup rules' do
    amended_rules = rules
    amended_rules["content_purpose_subgroup"]["guidance"] << news_and_communications_rule
    amended_rules["document_type"] = nil
    stub_load_rules(amended_rules)
    assert_equal %w(transparency news_and_communications), @links_out.links_out_supergroups
  end

  test 'links_out_supergroups returns correct supergroup names for document_type rules' do
    amended_rules = rules
    amended_rules["document_type"]["guide"] << news_and_communications_rule

    stub_load_rules(amended_rules)
    assert_equal %w(guidance_and_regulation news_and_communications), @links_out.links_out_supergroups
  end

  test 'links_out_subgroups returns correct subgroup names for content_purpose_supergroup rules' do
    amended_rules = rules
    amended_rules["content_purpose_supergroup"]["guidance_and_regulation"] << news_rule
    amended_rules["content_purpose_subgroup"] = nil
    amended_rules["document_type"] = nil

    stub_load_rules(amended_rules)
    assert_equal %w(link_to_news), @links_out.links_out_subgroups("news_and_communications")
  end

  test 'links_out_subgroups returns no subgroup names if content_purpose_subgroup is not a subgroup of the supergroup' do
    amended_rules = rules
    amended_rules["content_purpose_subgroup"]["guidance"] << news_rule
    amended_rules["document_type"] = nil

    stub_load_rules(amended_rules)
    assert_equal [], @links_out.links_out_subgroups("guidance_and_regulation")
  end

  test 'links_out_subgroups returns correct subgroup names for content_purpose_subgroup rules' do
    amended_rules = rules
    amended_rules["content_purpose_subgroup"]["guidance"] << news_rule
    amended_rules["document_type"] = nil

    stub_load_rules(amended_rules)
    assert_equal %w(link_to_news), @links_out.links_out_subgroups("news_and_communications")
  end

  test 'links_out_subgroups returns correct subgroup names for document_type rules' do
    amended_rules = rules
    amended_rules["document_type"]["guide"] << news_rule

    stub_load_rules(amended_rules)
    assert_equal %w(link_to_news), @links_out.links_out_subgroups("news_and_communications")
  end
end
