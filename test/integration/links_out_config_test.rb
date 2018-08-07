require 'test_helper'

class LinksOutConfigTest < ActionDispatch::IntegrationTest
  include ContentPagesNavTestHelper
  include GdsApi::TestHelpers::Rummager

  def setup_and_visit_content_item_with_taxonomy_grouping(name, taxonomy_grouping)
    taxonomy_grouping = default_taxonomy_grouping.merge(taxonomy_grouping)
    @content_item = get_content_example(name).tap do |item|
      item["links"]["taxons"] = SINGLE_TAXON
      item["content_purpose_supergroup"] = taxonomy_grouping["content_purpose_supergroup"]
      item["content_purpose_subgroup"] = taxonomy_grouping["content_purpose_subgroup"]
      item["document_type"] = taxonomy_grouping["document_type"]
      content_store_has_item(item["base_path"], item.to_json)
      visit_with_cachebust(item['base_path'])
    end
  end

  def default_taxonomy_grouping
    {
        "content_purpose_supergroup" => "guidance_and_regulation",
        "content_purpose_subgroup" => "guidance",
        "document_type" => "guide"
    }
  end

  def config
    Rails.configuration.taxonomy_navigation_links_out
  end

  def expected_supergroups(rule_level)
    config[rule_level].map { |rules| rules["supergroup"].humanize }
  end

  test "links out configuration is correct" do
    stub_rummager
    setup_variant_b
    config.keys.each do |rule_level|
      config[rule_level].keys.each do |rules|
        setup_and_visit_content_item_with_taxonomy_grouping('guide', rule_level => rules)
        expected_supergroups = expected_supergroups(config[rule_level])
        if expected_supergroups.any?
          assert_has_supergroup_navigation(expected_supergroups)
        else
          refute page.has_css?('taxonomy-navigation')
        end
      end
    end
  end

  # test "content_purpose_subgroup configuration is correct" do
  #   stub_rummager
  #   setup_variant_b
  #   conent_purpose_subgroup_config = config["content_purpose_subgroup"]
  #   conent_purpose_subgroup_config.keys.each do |document_type|
  #     setup_and_visit_content_item_with_taxonomy_grouping('guide', "document_type" => document_type)
  #     expected_supergroups = conent_purpose_subgroup_config[document_type].map { |rules| rules["supergroup"].humanize }
  #     if expected_supergroups.any?
  #       assert_has_supergroup_navigation(supergroup)
  #     else
  #       refute page.has_css?('taxonomy-navigation')
  #     end
  #   end
  # end
  #
  # test "content_purpose_subgroup configuration is correct" do
  #   stub_rummager
  #   setup_variant_b
  #   conent_purpose_subgroup_config = config["content_purpose_supergroup"]
  #   conent_purpose_subgroup_config.keys.each do |document_type|
  #     setup_and_visit_content_item_with_taxonomy_grouping('guide', "document_type" => document_type)
  #     expected_supergroups = conent_purpose_subgroup_config[document_type].map { |rules| rules["supergroup"].humanize }
  #     if expected_supergroups.any?
  #       assert_has_supergroup_navigation(supergroup)
  #     else
  #       refute page.has_css?('taxonomy-navigation')
  #     end
  #   end
  # end

  def assert_has_supergroup_navigation(expected_supergroups)
    within('.taxonomy-navigation') do
      expected_supergroups.each do |supergroup|
        assert page.has_css?('.gem-c-heading', text: supergroup)
      end
    end
  end

  def setup_variant_b
    ContentItemsController.any_instance.stubs(:show_new_navigation?).returns(true)
  end

  def schema_type
    "guide"
  end
end



