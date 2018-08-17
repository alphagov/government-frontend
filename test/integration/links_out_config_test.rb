require 'test_helper'

class LinksOutConfigTest < ActionDispatch::IntegrationTest
  include ContentPagesNavTestHelper
  include GdsApi::TestHelpers::Rummager
  include Capybara::Minitest::Assertions

  Rails.configuration.taxonomy_navigation_links_out.each do |name, group|
    group.each do |level, rules|
      test "links out configuration for #{name} #{level}" do
        stub_rummager
        setup_variant_b

        content_example = get_example_guide_with_single_taxon
        content_example[name] = level

        content_store_has_item content_example['base_path'], content_example.to_json
        visit_with_cachebust content_example['base_path']

        if rules.empty?
          refute_css '.taxonomy-navigation'
        else
          rules.each do |rule|
            assert_css '.taxonomy-navigation .gem-c-heading', text: rule['supergroup'].humanize
          end
        end
      end
    end
  end

  def get_example_guide_with_single_taxon
    get_content_example_by_schema_and_name('guide', 'guide').tap do |item|
      item['content_purpose_subgroup'] = 'guidance'
      item['content_purpose_supergroup'] = 'guidance_and_regulation'
      item['document_type'] = 'guide'
      item['links']['taxons'] = SINGLE_TAXON
    end
  end

  def setup_variant_b
    ContentItemsController.any_instance.stubs(:show_new_navigation?).returns(true)
  end
end
