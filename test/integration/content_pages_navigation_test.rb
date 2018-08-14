require 'test_helper'

class ContentPagesNavigationTest < ActionDispatch::IntegrationTest
  include ContentPagesNavTestHelper
  include GdsApi::TestHelpers::Rummager

  def setup
    stub_links_out_supergroups_to_include_all
  end

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

    assert page.has_css?('.taxonomy-navigation li', text: 'Becoming an apprentice')
    assert page.has_css?('.gem-c-highlight-boxes__title', text: 'Free school meals form')
  end

  test "ContentPagesNav variant B renders many taxons nicely" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide', THREE_TAXONS)

    within '.taxonomy-navigation' do
      assert page.has_css?('li a[href="/education/becoming-an-apprentice"]', text: 'Becoming an apprentice')
      assert page.has_css?('li a[href="/education/becoming-a-wizard"]', text: 'Becoming a wizard')
      assert page.has_css?('li a[href="/education/becoming-the-sorceror-supreme"]', text: 'Becoming the sorceror supreme')
    end

    assert page.has_css?('.gem-c-highlight-boxes__title', text: 'Free school meals form')
  end

  test "ContentPagesNav variant B only includes live taxons" do
    stub_rummager
    setup_variant_b

    taxons = SINGLE_TAXON + SINGLE_NON_LIVE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    within '.taxonomy-navigation' do
      assert page.has_css?('li a[href="/education/becoming-an-apprentice"]', text: 'Becoming an apprentice')
      refute page.has_css?('li a[href="/education/becoming-a-ghostbuster"]', text: 'Becoming a ghostbuster')
    end
  end

  test "ContentPagesNav variant A shows sidebar" do
    stub_rummager
    setup_sidebar_variant_a

    setup_and_visit_content_from_publishing_app(publishing_app: 'publisher')
    assert page.has_css?('.gem-c-contextual-sidebar')
  end

  test "ContentPagesNav variant B hides sidebar" do
    stub_rummager
    setup_sidebar_variant_b

    setup_and_visit_content_from_publishing_app(publishing_app: 'whitehall')
    refute page.has_css?('.gem-c-contextual-sidebar')
  end

  test "shows the Services section title and documents with tracking" do
    stub_rummager
    stub_empty_guidance
    stub_empty_news
    stub_empty_policies
    stub_empty_transparency
    setup_variant_b

    taxons = SINGLE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    assert page.has_css?('h3', text: "Services")
    assert page.has_css?('.gem-c-highlight-boxes__title', text: 'Free school meals form')
    assert page.has_css?('.gem-c-highlight-boxes__title[data-track-category="servicesHighlightBoxClicked"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-highlight-boxes__title[data-track-action="1"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-highlight-boxes__title[data-track-label="/government/publications/meals"]', text: 'Free school meals form')
  end

  test "does not show the Services section if there is no tagged content" do
    stub_empty_rummager
    setup_variant_b

    taxons = SINGLE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    refute page.has_css?('h3', text: "Services")
  end

  test "shows the Policy section title and documents with tracking" do
    stub_rummager
    stub_empty_guidance
    stub_empty_news
    stub_empty_services
    stub_empty_transparency
    setup_variant_b

    taxons = SINGLE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    assert page.has_css?('h3', text: "Policy and engagement")

    assert page.has_css?('.gem-c-document-list__item a[data-track-category="policyAndEngagementDocumentListClicked"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-action="1"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-label="/government/publications/meals"]', text: 'Free school meals form')
  end

  test "does not show the Policy section if there is no tagged content" do
    stub_empty_rummager
    setup_variant_b

    taxons = SINGLE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    refute page.has_css?('h3', text: "Policy and engagement")
  end

  test "shows the Guidance section title and documents with tracking" do
    stub_rummager
    stub_empty_policies
    stub_empty_news
    stub_empty_services
    stub_empty_transparency
    setup_variant_b

    taxons = SINGLE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    assert_has_guidance_and_regulation_section
  end

  test "does not show the Guidance section if there is no tagged content" do
    stub_empty_rummager
    setup_variant_b

    taxons = SINGLE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    refute page.has_css?('h3', text: "Guidance and regulation")
  end

  test "shows the Transparency section title and documents with tracking" do
    stub_rummager
    stub_empty_guidance
    stub_empty_news
    stub_empty_policies
    stub_empty_services
    setup_variant_b

    taxons = SINGLE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    assert_has_transparency_section
  end

  test "does not show the Transparency section if there is no tagged content" do
    stub_empty_rummager
    setup_variant_b

    taxons = SINGLE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    refute page.has_css?('h3', text: "Guidance and regulation")
  end

  test "shows the News and comms section title and documents with tracking" do
    stub_rummager
    stub_empty_services
    stub_empty_guidance
    stub_empty_policies
    stub_empty_transparency
    setup_variant_b

    taxons = SINGLE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    assert_has_news_and_communications_section
  end

  test "does not show the News and comms section if there is no tagged content" do
    stub_empty_rummager
    setup_variant_b

    taxons = SINGLE_TAXON

    setup_and_visit_content_item_with_taxons('guide', taxons)

    refute page.has_css?('h3', text: "News and communications")
  end

  test "ContentPagesNav variant A shows explore the topic in the sidebar" do
    setup_variant_a

    setup_and_visit_content_item('guide')

    assert page.has_css?('.gem-c-related-navigation__sub-heading', text: 'Explore the topic')
  end

  test "ContentPagesNav variant B does not show explore the topic in the sidebar" do
    setup_variant_b

    setup_and_visit_content_item('guide')

    refute page.has_css?('.gem-c-related-navigation__sub-heading', text: 'Explore the topic')
  end

  test "shows parent-based breadcrumbs if variant a" do
    stub_empty_rummager
    taxons = THREE_TAXONS
    setup_and_visit_content_item_with_taxons('guide', taxons)

    within('.gem-c-contextual-breadcrumbs') do
      assert page.has_css?('a', text: "Home")
      assert page.has_css?('a', text: "Childcare and parenting")
      assert page.has_css?('a', text: "Schools and education")
    end
  end

  test "ContentPagesNav variant B when a page belongs to a single topic shows full breadcrumb" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide', SINGLE_TAXON)

    within('.gem-c-contextual-breadcrumbs') do
      assert page.has_css?('a', text: 'Home')
      assert page.has_css?('a', text: 'Becoming an apprentice')
    end

    refute page.has_css?('.taxonomy-navigation__banner')
  end

  test "ContentPagesNav variant B shows home breadcrumb when a page belongs to a two topics" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide', TWO_TAXONS)

    within('.gem-c-contextual-breadcrumbs') do
      assert page.has_css?('a', text: 'Home')
      refute page.has_css?('a', text: 'Becoming an apprentice')
      refute page.has_css?('a', text: 'Becoming a wizard')
    end
  end

  test "ContentPagesNav variant B shows banner when a page belongs to two topics" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide', TWO_TAXONS)

    within('.taxonomy-navigation__banner') do
      assert page.has_content?('This page is part of Becoming an apprentice and Becoming a wizard')
      assert page.has_css?('a', text: 'Becoming an apprentice')
      assert page.has_css?('a', text: 'Becoming a wizard')
    end
  end

  test "ContentPagesNav variant B shows breadcrumb when a page belongs to more than two topics" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide', THREE_TAXONS)

    within('.gem-c-contextual-breadcrumbs') do
      assert page.has_css?('a', text: 'Home')
      refute page.has_css?('a', text: 'Becoming an apprentice')
      refute page.has_css?('a', text: 'Becoming a wizard')
      refute page.has_css?('a', text: 'Becoming the sorceror supreme')
    end
  end

  test "ContentPagesNav variant B shows banner when a page belongs to more than two topics" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide', THREE_TAXONS)

    within('.taxonomy-navigation__banner') do
      assert page.has_content?('This page is part of Becoming an apprentice and 2 others + show all')
      assert page.has_css?('a', text: 'Becoming an apprentice')
      assert page.has_css?('a', text: 'Becoming a wizard')
      assert page.has_css?('a', text: 'Becoming the sorceror supreme')
    end
  end

  test "ContentPagesNav variant B shows full breadcrumb when a page belongs to a single topic and a step by step" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide-with-step-navs', SINGLE_TAXON)

    within('.gem-c-contextual-breadcrumbs') do
      assert page.has_css?('a', text: 'Home')
      assert page.has_css?('a', text: 'Becoming an apprentice')
    end
  end

  test "ContentPagesNav variant B shows banner when a page belongs to a single topic and a step by step" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide-with-step-navs', SINGLE_TAXON)

    within('.taxonomy-navigation__banner') do
      assert page.has_content?('This page is part of Learn to drive a car: step by step')
      assert page.has_css?('a', text: 'Learn to drive a car: step by step')
    end
  end

  test "ContentPagesNav variant B shows home breadcrumb when a page belongs to a two topics and a step by step" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide-with-step-navs', TWO_TAXONS)

    within('.gem-c-contextual-breadcrumbs') do
      assert page.has_css?('a', text: 'Home')
      refute page.has_css?('a', text: 'Becoming an apprentice')
      refute page.has_css?('a', text: 'Becoming a wizard')
    end
  end

  test "ContentPagesNav variant B shows banner when a page belongs to two topics and a step by step" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide-with-step-navs', TWO_TAXONS)

    within('.taxonomy-navigation__banner') do
      assert page.has_content?('This page is part of Learn to drive a car: step by step and 2 others + show all')
      assert page.has_content?('Becoming an apprentice and Becoming a wizard')
      assert page.has_css?('a', text: 'Learn to drive a car')
      assert page.has_css?('a', text: 'Becoming an apprentice')
      assert page.has_css?('a', text: 'Becoming a wizard')
    end
  end

  test "ContentPagesNav variant B shows home breadcrumb when a page belongs to more than two topics and a step by step" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide-with-step-navs', THREE_TAXONS)

    within('.gem-c-contextual-breadcrumbs') do
      assert page.has_css?('a', text: 'Home')
      refute page.has_css?('a', text: 'Becoming an apprentice')
      refute page.has_css?('a', text: 'Becoming a wizard')
      refute page.has_css?('a', text: 'Becoming the sorceror supreme')
    end
  end

  test "ContentPagesNav variant B shows banner when a page belongs to more than two topics and a step by step" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide-with-step-navs', THREE_TAXONS)

    within('.taxonomy-navigation__banner') do
      assert page.has_content?('This page is part of Learn to drive a car: step by step and 3 others + show all')
      assert page.has_content?('Becoming an apprentice, Becoming a wizard, and Becoming the sorceror supreme')
      assert page.has_css?('a', text: 'Learn to drive a car')
      assert page.has_css?('a', text: 'Becoming an apprentice')
      assert page.has_css?('a', text: 'Becoming a wizard')
      assert page.has_css?('a', text: 'Becoming the sorceror supreme')
    end
  end

  test "links out will filter out supergroups not in the configuration" do
    stub_rummager
    setup_variant_b
    taxons = THREE_TAXONS
    supergroups.each do |supergroup_to_exclude|
      supergroups_to_include = supergroups.delete_if { |supergroup| supergroup == supergroup_to_exclude }
      stub_links_out_supergroups(supergroups_to_include)
      setup_and_visit_content_item_with_taxons('guide', taxons)
      supergroups_to_include.each do |included_supergroup|
        send("assert_has_#{included_supergroup}_section")
      end
      refute page.has_css?('h3', text: supergroup_to_exclude.humanize)
    end
  end

  test "ContentPagesNav variant B shows BETA phase message and survey link" do
    stub_rummager
    setup_variant_b

    setup_and_visit_content_item_with_taxons('guide', SINGLE_TAXON)

    within('.gem-c-phase-banner') do
      assert page.has_css?('.phase-tag', text: 'BETA')

      assert page.has_content?('This is a test version of the layout of this page.')

      assert page.has_css?('a[href="https://www.smartsurvey.co.uk/s/navigationsurvey2018?c=/national-curriculum"]',
                           text: 'Take the survey to help us improve it')
    end
  end

  def stub_empty_services
    Supergroups::Services.any_instance.stubs(:tagged_content).returns({})
  end

  def stub_empty_guidance
    Supergroups::GuidanceAndRegulation.any_instance.stubs(:tagged_content).returns([])
  end

  def stub_empty_news
    Supergroups::NewsAndCommunications.any_instance.stubs(:tagged_content).returns([])
  end

  def stub_empty_policies
    Supergroups::PolicyAndEngagement.any_instance.stubs(:tagged_content).returns([])
  end

  def stub_empty_transparency
    Supergroups::Transparency.any_instance.stubs(:tagged_content).returns([])
  end

  def setup_variant_a
    ContentItemsController.any_instance.stubs(:show_new_navigation?).returns(false)
  end

  def setup_variant_b
    ContentItemsController.any_instance.stubs(:show_new_navigation?).returns(true)
  end

  def setup_sidebar_variant_a
    ContentItemsController.any_instance.stubs(:should_show_sidebar?).returns(true)
  end

  def setup_sidebar_variant_b
    ContentItemsController.any_instance.stubs(:should_show_sidebar?).returns(false)
  end

  def schema_type
    "guide"
  end
end
