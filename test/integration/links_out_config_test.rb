require 'test_helper'

class LinksOutConfigTest < ActionDispatch::IntegrationTest
  include ContentPagesNavTestHelper
  include GdsApi::TestHelpers::Rummager

  def schema_type
    "guide"
  end

  def setup_variant_b
    ContentItemsController.any_instance.stubs(:show_new_navigation?).returns(true)
  end

  def setup_and_visit_content_item_with_taxonomy_grouping(name, taxonomy_grouping)
    taxonomy_grouping = default_taxonomy_grouping.merge(taxonomy_grouping)
    @content_item = get_content_example(name).tap do |item|
      item["links"]["taxons"] = SINGLE_TAXON
      item["content_purpose_supergroup"] = taxonomy_grouping["content_purpose_supergroup"]
      item["content_purpose_subgroup"] = taxonomy_grouping["content_purpose_subgroup"]
      item["document_type"] = taxonomy_grouping["document_type"]
      content_store_has_item(item["base_path"], item.to_json)
      visit_with_cachebust(item["base_path"])
    end
  end

  def default_taxonomy_grouping
    {
        "content_purpose_supergroup" => "guidance_and_regulation",
        "content_purpose_subgroup" => "guidance",
        "document_type" => "guide"
    }
  end

  def taxon_config
    Rails.configuration.taxonomy_navigation_links_out || YAML.safe_load(File.read("config/taxonomy_navigation_links_out.yml"))["default"]
  end

  def expected_supergroups(rule_level)
    rule_level.map { |rules| rules["supergroup"].humanize }
  end

  def assert_has_supergroup_navigation(expected_supergroups)
    within('.taxonomy-navigation') do
      expected_supergroups.each do |supergroup|
        assert page.has_css?('.gem-c-heading', text: supergroup)
      end
    end
  end

  test "links out configuration causes no errors and correct supergroups are displayed for each ruleset" do
    stub_rummager
    setup_variant_b
    using_wait_time 30 do
      taxon_config.each_key do |taxonomy_rule_level|
        taxon_config[taxonomy_rule_level].each_key do |rules_for_taxon|
          setup_and_visit_content_item_with_taxonomy_grouping("guide", taxonomy_rule_level => rules_for_taxon)
          expected_supergroups = expected_supergroups(taxon_config[taxonomy_rule_level][rules_for_taxon])
          if expected_supergroups.any?
            assert_has_supergroup_navigation(expected_supergroups)
          else
            refute page.has_css?('taxonomy-navigation')
          end
        end
      end
    end
  end
end
