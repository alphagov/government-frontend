require 'test_helper'

class ContentPagesNavigationTest < ActionDispatch::IntegrationTest
  include ContentPagesNavTestHelper
  include GdsApi::TestHelpers::Rummager

  test "ContentPagesNav variant A does not show taxonomy navigation for single taxon" do
    setup_variant_a

    setup_and_visit_content_item_with_taxons('guide', SINGLE_TAXON)

    refute page.has_css?('.taxonomy-navigation')
  end

  test "ContentPagesNav variant B does not show taxonomy navigation for content not tagged to a taxon" do
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide', [])

    refute page.has_css?('.taxonomy-navigation')
  end

  test "ContentPagesNav variant B shows taxonomy navigation for single taxon" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide', SINGLE_TAXON)

    assert page.has_css?('.taxonomy-navigation h2', text: 'Becoming an apprentice')
    assert page.has_css?('.gem-c-highlight-boxes__title', text: 'Apprenticeship agreement: template')
  end

  test "ContentPagesNav variant B renders many taxons nicely" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide', THREE_TAXONS)

    assert page.has_css?('.taxonomy-navigation h2', text: 'Becoming an apprentice')
    assert page.has_css?('.taxonomy-navigation h2', text: 'Becoming a wizard')
    assert page.has_css?('.taxonomy-navigation h2', text: 'Becoming the sorceror supreme')

    assert page.has_css?('.gem-c-highlight-boxes__title', text: 'Apprenticeship agreement: template')
  end

  test "ContentPagesNav variant B only includes live taxons" do
    stub_rummager
    setup_variant_b

    taxons = SINGLE_TAXON + SINGLE_NON_LIVE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    assert page.has_css?('.taxonomy-navigation h2', text: 'Becoming an apprentice')
    refute page.has_css?('.taxonomy-navigation h2', text: 'Becoming a ghostbuster')

    assert page.has_css?('.gem-c-highlight-boxes__title', text: 'Apprenticeship agreement: template')
  end

  def setup_variant_a
    ContentItemsController.any_instance.stubs(:show_new_navigation?).returns(false)
  end

  def setup_variant_b
    ContentItemsController.any_instance.stubs(:show_new_navigation?).returns(true)
  end

  def schema_type
    "guide"
  end
end
