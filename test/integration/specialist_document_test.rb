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

  test "renders from in metadata and document footer" do
    setup_and_visit_content_item('aaib-reports')

    aaib = "<a href=\"/government/organisations/air-accidents-investigation-branch\">Air Accidents Investigation Branch</a>"
    assert_has_component_metadata_pair("from", [aaib])
    assert_has_component_document_footer_pair("from", [aaib])
  end

  test "renders published and updated in metadata and document footer" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    assert_has_component_metadata_pair("first_published", "2 April 2015")
    assert_has_component_metadata_pair("last_updated", "29 March 2016")

    assert_has_component_document_footer_pair("published", "2 April 2015")
    assert_has_component_document_footer_pair("updated", "29 March 2016")
  end

  test "renders change history in reverse chronological order" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    within shared_component_selector("document_footer") do
      component_args = JSON.parse(page.text)
      history = component_args.fetch("history")
      assert_equal history.first["note"], @content_item["details"]["change_history"].last["note"]
      assert_equal history.last["note"], @content_item["details"]["change_history"].first["note"]
      assert_equal history.size, @content_item["details"]["change_history"].size
    end
  end

  test "renders text facets correctly" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    def test_meta(component)
      tiers = [
        "<a href=\"/countryside-stewardship-grants?tiers_or_standalone_items%5B%5D=higher-tier\">Higher Tier</a>",
        "<a href=\"/countryside-stewardship-grants?tiers_or_standalone_items%5B%5D=mid-tier\">Mid Tier</a>"
      ]

      land_use = [
        "<a href=\"/countryside-stewardship-grants?land_use%5B%5D=arable-land\">Arable land</a>",
        "<a href=\"/countryside-stewardship-grants?land_use%5B%5D=wildlife-package\">Wildlife package</a>",
        "<a href=\"/countryside-stewardship-grants?land_use%5B%5D=water-quality\">Water quality</a>",
        "<a href=\"/countryside-stewardship-grants?land_use%5B%5D=wildlife-package\">Wildlife package</a>"
      ]

      within shared_component_selector(component) do
        component_args = JSON.parse(page.text)
        assert_equal component_args["other"]["Grant type"], "<a href=\"/countryside-stewardship-grants?grant_type%5B%5D=option\">Option</a>"
        assert_equal component_args["other"]["Tiers or standalone items"], tiers
        assert_equal component_args["other"]["Land use"], land_use
        assert_equal component_args["other"]["Funding (per unit per year)"],
        "<a href=\"/countryside-stewardship-grants?funding_amount%5B%5D=more-than-500\">More than £500</a>"
      end
    end
    test_meta("document_footer")
    test_meta("metadata")
  end

  test "renders date facets correctly" do
    setup_and_visit_content_item('drug-device-alerts')

    within shared_component_selector("document_footer") do
      component_args = JSON.parse(page.text)
      assert_equal component_args["other_dates"]["Issued"], "6 July 2015"
    end

    within shared_component_selector("metadata") do
      component_args = JSON.parse(page.text)
      assert_equal component_args["other"]["Issued"], "6 July 2015"
    end
  end

  test "renders when no facet or finder" do
    setup_and_visit_content_item('business-finance-support-scheme')
    assert_has_component_metadata_pair("first_published", "9 July 2015")

    within shared_component_selector("document_footer") do
      component_args = JSON.parse(page.text)
      assert_equal component_args["other_dates"], {}
    end

    within shared_component_selector("metadata") do
      component_args = JSON.parse(page.text)
      assert_equal component_args["other"], {}
    end
  end

  test "renders a nested contents list" do
    setup_and_visit_content_item('aaib-reports')

    assert page.has_css?(".contents-list.contents-list-nested")
    within ".contents-list.contents-list-nested" do
      @content_item['details']['headers'].each do |heading|
        assert_nested_content_item(heading)
      end
    end
  end

  test "renders a nested contents list with level 2 and 3 headings only" do
    setup_and_visit_content_item('drug-device-alerts')

    within ".contents-list.contents-list-nested" do
      @content_item['details']['headers'].each do |heading|
        assert_nested_content_item(heading)
      end
    end
  end

  def assert_nested_content_item(heading)
    heading_level = heading["level"]
    selector = ".nested-contents-link-h#{heading_level}[href=\"##{heading['id']}\"]"
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

    assert page.has_no_css?('.button')
  end

  test 'renders start button' do
    setup_and_visit_content_item('business-finance-support-scheme')

    button_base_selector = '.button.button-start'
    correct_role_selector = '[role=button]'
    correct_href_selector = '[href="http://www.bigissueinvest.com"]'

    expected_button_selector =
      button_base_selector +
      correct_role_selector +
      correct_href_selector

    assert page.has_css?(expected_button_selector)
    within expected_button_selector do
      assert_text('Find out more')
    end

    button_info_selector = '.button-info-text'
    assert page.has_css?(button_info_selector)
    within button_info_selector do
      assert_text('on the Big Issue Invest website')
    end
  end
end
