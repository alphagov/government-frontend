require 'test_helper'

class TaxonomyNavigationTest < ActiveSupport::TestCase
  include GdsApi::TestHelpers::Rummager
  include ContentPagesNavTestHelper

  def setup
    @taxonomy_navigation = Object.new
    @taxonomy_navigation.extend(ContentItem::TaxonomyNavigation)
    class << @taxonomy_navigation
      def content_item
        {
            "content_purpose_supergroup" => "guidance_and_regulation",
            "content_purpose_subgroup" => "guidance",
            "document_type" => "guide",
        }
      end
    end
    @taxonomy_navigation.instance_variable_set(:@taxons, SINGLE_TAXON)
    stub_rummager
  end

  def rule_one_supergroup
    {
        "content_purpose_supergroup" => {
            "guidance_and_regulation" => [
                {
                    "title" => "link_to_guidance_and_regulation",
                    "type" => "content_purpose_supergroup",
                    "supergroup" => "services"
                }
            ]
        }
    }
  end

  def rule_all_supergroups
    {
        "content_purpose_supergroup" => {
            "guidance_and_regulation" => [
                {
                    "title" => "link_to_guidance_and_regulation",
                    "type" => "content_purpose_supergroup",
                    "supergroup" => "guidance_and_regulation"
                },
                {
                    "title" => "link_to_guidance_and_regulation",
                    "type" => "content_purpose_supergroup",
                    "supergroup" => "transparency"
                },
                {
                    "title" => "link_to_guidance_and_regulation",
                    "type" => "content_purpose_supergroup",
                    "supergroup" => "news_and_communications"
                },
                {
                    "title" => "link_to_guidance_and_regulation",
                    "type" => "content_purpose_supergroup",
                    "supergroup" => "policy_and_engagement"
                },
                {
                    "title" => "link_to_guidance_and_regulation",
                    "type" => "content_purpose_supergroup",
                    "supergroup" => "services"
                }
            ]
        }
    }
  end

  def stub_load_rules(rules)
    Rails.configuration.stubs(:taxonomy_navigation_links_out).returns(rules)
  end

  test 'links_out_supergroups returns empty hash if there are no rules' do
    stub_load_rules({})
    assert_equal Hash.new, @taxonomy_navigation.taxonomy_navigation("some/path")
  end

  test 'links_out_supergroups returns hash with only services if the rules has only services' do
    stub_load_rules(rule_one_supergroup)
    assert_equal [:services], @taxonomy_navigation.taxonomy_navigation("some/path").keys
    assert_equal 4, @taxonomy_navigation.taxonomy_navigation("some/path")[:services].count
  end

  test 'links_out_supergroups returns hash with all supergroups if the rules has all supergroups' do
    stub_load_rules(rule_all_supergroups)
    taxonomy_navigation = @taxonomy_navigation.taxonomy_navigation("some/path")
    assert_equal %i(guidance_and_regulation transparency news_and_communications policy_and_engagement services), taxonomy_navigation.keys
    supergroups.each do |supergroup|
      assert_equal 4, taxonomy_navigation[supergroup.to_sym].count
    end
  end
end
