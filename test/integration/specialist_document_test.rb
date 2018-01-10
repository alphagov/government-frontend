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

  test "renders from in publisher metadata" do
    setup_and_visit_content_item('aaib-reports')

    within(".app-c-publisher-metadata__other") do
      assert page.has_content?("From: Air Accidents Investigation Branch")
      assert page.has_link?("Air Accidents Investigation Branch",
                            href: "/government/organisations/air-accidents-investigation-branch")
    end
  end

  test "renders published and updated in metadata" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    within(all(".app-c-published-dates").first) do
      assert page.has_content?("Published 2 April 2015")
      assert page.has_content?("Last updated 29 March 2016")
    end
  end

  test "renders change history in reverse chronological order" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    within(".app-c-published-dates__change-history") do
      assert_match @content_item["details"]["change_history"].last["note"],
        page.find(".app-c-published-dates__change-item:first-child").text

      assert_match @content_item["details"]["change_history"].first["note"],
        page.find(".app-c-published-dates__change-item:last-child").text

      assert_equal all(".app-c-published-dates__change-item").size,
        @content_item["details"]["change_history"].size
    end
  end

  test "renders text facets correctly" do
    setup_and_visit_content_item('countryside-stewardship-grants')


    within(".app-c-important-metadata") do
      assert page.all(".app-c-important-metadata__term")[0].has_content?("Grant type")
      within(all(".app-c-important-metadata__definition")[0]) do
        assert page.has_link?("Option", href: "/countryside-stewardship-grants?grant_type%5B%5D=option")
      end

      assert page.all(".app-c-important-metadata__term")[1].has_content?("Land use")
      within(all(".app-c-important-metadata__definition")[1]) do
        assert page.has_link?("Arable land",
                              href: "/countryside-stewardship-grants?land_use%5B%5D=arable-land")
        assert page.has_link?("Wildlife package",
                              href: "/countryside-stewardship-grants?land_use%5B%5D=wildlife-package")
        assert page.has_link?("Water quality",
                              href: "/countryside-stewardship-grants?land_use%5B%5D=water-quality")
      end

      assert page.all(".app-c-important-metadata__term")[2].has_content?("Tiers or standalone items")
      within(all(".app-c-important-metadata__definition")[2]) do
        assert page.has_link?("Higher Tier",
                              href: "/countryside-stewardship-grants?tiers_or_standalone_items%5B%5D=higher-tier")
        assert page.has_link?("Mid Tier",
                              href: "/countryside-stewardship-grants?tiers_or_standalone_items%5B%5D=mid-tier")
      end

      assert page.all(".app-c-important-metadata__term")[3].has_content?("Funding (per unit per year)")
      within(all(".app-c-important-metadata__definition")[3]) do
        assert page.has_link?("More than £500",
                              href: "/countryside-stewardship-grants?funding_amount%5B%5D=more-than-500")
      end
    end
  end

  test "renders date facets correctly" do
    setup_and_visit_content_item('drug-device-alerts')

    within(all(".app-c-published-dates").last) do
      assert page.has_content?("Published 6 July 2015")
    end

    within(".app-c-important-metadata") do
      assert page.has_css?(".app-c-important-metadata__term", text: "Issued")
      assert page.has_css?(".app-c-important-metadata__definition", text: "6 July 2015")
    end
  end

  test "renders when no facet or finder" do
    setup_and_visit_content_item('business-finance-support-scheme')

    within(all(".app-c-published-dates").first) do
      assert page.has_content?("Published 9 July 2015")
    end
  end

  test "renders a nested contents list" do
    setup_and_visit_content_item('aaib-reports')

    assert page.has_css?("#contents .app-c-contents-list")
    assert page.has_css?(%(#contents .app-c-contents-list-with-body__link-wrapper
                          .app-c-contents-list-with-body__link-container a.app-c-back-to-top))

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
