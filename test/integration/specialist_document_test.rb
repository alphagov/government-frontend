require 'test_helper'

class SpecialistDocumentTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item(document_type: 'aaib_report')
    setup_and_visit_random_content_item(document_type: 'raib_report')
    setup_and_visit_random_content_item(document_type: 'tax_tribunal_decision')
    setup_and_visit_random_content_item(document_type: 'cma_case')
  end

  test "renders title, description and body" do
    setup_and_visit_content_item('aaib-reports')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "renders from in metadata" do
    setup_and_visit_content_item('aaib-reports')

    within(".app-c-publisher-metadata") do
      within(".app-c-publisher-metadata__other") do
        assert page.has_content?("From: Air Accidents Investigation Branch")
        assert page.has_link?('Air Accidents Investigation Branch', href: '/government/organisations/air-accidents-investigation-branch')
      end
    end
  end

  test "renders publisher metadata" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    within(".app-c-publisher-metadata") do
      within(".app-c-published-dates") do
        assert page.has_content?("Published 2 April 2015")
        assert page.has_content?("Last updated 29 March 2016")
      end
    end
    within(".app-c-content-footer") do
      assert page.has_content?("Published 2 April 2015")
      assert page.has_content?("14 October 2015")
    end
  end

  test "renders change history in reverse chronological order" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    within(".app-c-content-footer") do
      assert_equal page.all(".app-c-published-dates__change-item").count, @content_item["details"]["change_history"].size
      within(".app-c-published-dates__change-item:last-child") do
        assert page.has_content?(@content_item["details"]["change_history"].first["note"])
      end
      within(".app-c-published-dates__change-item:first-child") do
        assert page.has_content?(@content_item["details"]["change_history"].last["note"])
      end
    end
  end

  test "renders text facets correctly" do
    setup_and_visit_content_item('countryside-stewardship-grants')
    tiers = {
      "Higher Tier" => "/countryside-stewardship-grants?tiers_or_standalone_items%5B%5D=higher-tier",
      "Mid Tier"    => "/countryside-stewardship-grants?tiers_or_standalone_items%5B%5D=mid-tier"
    }
    land_use = {
     "Arable land" => "/countryside-stewardship-grants?land_use%5B%5D=arable-land",
     "Wildlife package" => "/countryside-stewardship-grants?land_use%5B%5D=wildlife-package",
     "Water quality" => "/countryside-stewardship-grants?land_use%5B%5D=water-quality"
    }
    within(".app-c-important-metadata") do
      assert page.has_content?("Grant type: Option")
      assert page.has_link?('Option', href: '/countryside-stewardship-grants?grant_type%5B%5D=option')
      assert page.has_content?("Funding (per unit per year): More than £500")
      assert page.has_link?('More than £500', href: '/countryside-stewardship-grants?funding_amount%5B%5D=more-than-500')

      tiers.each do |key, value|
        assert page.has_link?(key.to_s, href: value.to_s)
        assert page.has_content?(tiers.keys.join(","))
      end

      land_use.each do |key, value|
        assert page.has_link?(key.to_s, href: value.to_s)
      end
    end
  end

  test "renders date facets correctly" do
    setup_and_visit_content_item('drug-device-alerts')

    within(".app-c-important-metadata") do
      assert page.has_content?("Issued: 6 July 2015")
    end
  end

  test "renders when no facet or finder" do
    setup_and_visit_content_item('business-finance-support-scheme')

    within(".app-c-publisher-metadata") do
      within(".app-c-published-dates") do
        assert page.has_content?("Published 9 July 2015")
      end
    end
    assert page.has_no_selector?(:css, '#full-history')
    assert page.has_no_selector?(:css, '.app-c-publisher-metadata__other')
  end

  test "renders a nested contents list" do
    setup_and_visit_content_item('aaib-reports')

    assert page.has_css?(".app-c-contents-list")
    within ".app-c-contents-list" do
      @content_item['details']['headers'].each do |heading|
        assert_nested_content_item(heading)
      end
    end
  end

  test "renders a nested contents list with level 2 and 3 headings only" do
    setup_and_visit_content_item('drug-device-alerts')

    within ".app-c-contents-list" do
      @content_item['details']['headers'].each do |heading|
        assert_nested_content_item(heading)
      end
    end
  end

  def assert_nested_content_item(heading)
    heading_level = heading["level"]
    selector = "a[href=\"##{heading['id']}\"]"
    text = heading["text"].gsub(/\:$/, '')

    if heading_level < 4
      assert page.has_css?(selector), "Failed to find an element matching: #{selector}"
      assert page.has_css?(selector, text: text), "Failed to find an element matching #{selector} with text: #{text}"
    else
      refute page.has_css?(selector), "Found a nested heading too deep, there should be no element matching: #{selector}"
    end

    if heading["headers"].present?
      heading["headers"].each do |h|
        assert_nested_content_item(h)
      end
    end
  end

  test 'renders no start button when not set' do
    setup_and_visit_content_item('aaib-reports')

    assert_no_component('button')
  end

  test 'renders start button' do
    setup_and_visit_content_item('business-finance-support-scheme')

    assert_component_locals(
      'button',
      start: true,
      href: 'http://www.bigissueinvest.com',
      info_text: 'on the Big Issue Invest website',
      text: 'Find out more'
    )
  end
end
