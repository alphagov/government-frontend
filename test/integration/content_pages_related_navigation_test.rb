require 'test_helper'

class ContentPagesRelatedNavigationTest < ActionDispatch::IntegrationTest
  include ContentPagesNavTestHelper
  include GdsApi::TestHelpers::Rummager

  def setup
    stub_links_out_supergroups_to_include_all
  end

  test "ContentPagesNav variant A shows related collections in the sidebar" do
    setup_variant_a

    setup_and_visit_content_item('case_study')

    assert page.has_css?('.gem-c-related-navigation__sub-heading', text: 'Collection')
  end

  test "ContentPagesNav variant B shows tagged taxons in the taxonomy navigation" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('case_study', SINGLE_TAXON)

    within '.taxonomy-navigation' do
      assert page.has_css?('.gem-c-heading', text: 'Topics')
      assert page.has_css?('.taxonomy-navigation__list-item a', text: 'Becoming an apprentice')
      assert page.has_css?('.taxonomy-navigation__list-item a[data-track-category="relatedTaxonomyLinkClicked"]', text: 'Becoming an apprentice')
      assert page.has_css?('.taxonomy-navigation__list-item a[data-track-action="1.0 Topics"]', text: 'Becoming an apprentice')
      assert page.has_css?('.taxonomy-navigation__list-item a[data-track-label="/education/becoming-an-apprentice"]')
    end
  end

  test "ContentPagesNav variant B shows related collections in the taxonomy navigation" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('case_study', SINGLE_TAXON)

    within '.taxonomy-navigation' do
      assert page.has_css?('.gem-c-heading', text: 'Collections')
      assert page.has_css?('.taxonomy-navigation__list-item a', text: 'Work Programme real life stories')
      assert page.has_css?('.taxonomy-navigation__list-item a[data-track-category="relatedTaxonomyLinkClicked"]', text: 'Work Programme real life stories')
      assert page.has_css?('.taxonomy-navigation__list-item a[data-track-action="2.0 Collections"]', text: 'Work Programme real life stories')
      assert page.has_css?('.taxonomy-navigation__list-item a[data-track-label="/government/collections/work-programme-real-life-stories"]')
    end
  end

  test "ContentPagesNav variant B does not show related collections in the sidebar" do
    setup_variant_b

    setup_and_visit_content_item('case_study')

    refute page.has_css?('.gem-c-related-navigation__sub-heading', text: 'Collection')
  end

  def setup_variant_a
    ContentItemsController.any_instance.stubs(:show_new_navigation?).returns(false)
  end

  def setup_variant_b
    ContentItemsController.any_instance.stubs(:show_new_navigation?).returns(true)
  end

  def schema_type
    "case_study"
  end
end
