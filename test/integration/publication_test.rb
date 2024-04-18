require "test_helper"

class PublicationTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item(document_type: "statutory_guidance")
  end

  test "publication" do
    setup_and_visit_content_item("publication")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within "#details" do
      assert page.has_text?("Installation name: Leeming Biogas Facility")
    end
  end

  test "renders metadata and document footer" do
    setup_and_visit_content_item("publication")

    assert_has_metadata({
      published: "3 May 2016",
      from: {
        "Environment Agency": "/government/organisations/environment-agency",
        "The Rt Hon Sir Eric Pickles MP": "/government/people/eric-pickles",
      },
    })

    assert_has_structured_data(page, "Article")

    assert_footer_has_published_dates("Published 3 May 2016")
  end

  test "does not render non-featured attachments" do
    overrides = {
      "details" => {
        "attachments" => [{
          "accessible" => false,
          "alternative_format_contact_email" => "customerservices@publicguardian.gov.uk",
          "attachment_type" => "file",
          "command_paper_number" => "",
          "content_type" => "application/pdf",
          "file_size" => 123_456,
          "filename" => "veolia-permit.pdf",
          "hoc_paper_number" => "",
          "id" => "violia-permit",
          "isbn" => "",
          "locale" => "en",
          "title" => "Permit: Veolia ES (UK) Limited",
          "unique_reference" => "",
          "unnumbered_command_paper" => false,
          "unnumbered_hoc_paper" => false,
          "url" => "https://assets.publishing.service.gov.uk/media/123abc/veolia-permit.zip",
        }],
        "featured_attachments" => [],
      },
    }

    setup_and_visit_content_item("publication", overrides)
    assert page.has_no_text?("Permit: Veolia ES (UK) Limited")
  end

  test "renders featured document attachments using components" do
    setup_and_visit_content_item("publication-with-featured-attachments")
    within "#documents" do
      assert page.has_text?("Number of ex-regular service personnel now part of FR20")
      assert page.has_css?(".gem-c-attachment")
    end
  end

  test "doesn't render the documents section if no documents" do
    overrides = {
      "details" => {
        "attachments" => [{}],
      },
    }
    setup_and_visit_content_item("publication-with-featured-attachments", overrides)
    assert page.has_no_text?("Documents")
  end

  test "renders accessible format option when accessible is false and email is supplied" do
    overrides = {
      "details" => {
        "attachments" => [{
          "accessible" => false,
          "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
          "attachment_type" => "file",
          "id" => "PUBLIC_1392629965.pdf",
          "title" => "Number of ex-regular service personnel now part of FR20",
          "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
          "command_paper_number" => "",
          "hoc_paper_number" => "",
          "isbn" => "",
          "unique_reference" => "",
          "unnumbered_command_paper" => false,
          "unnumbered_hoc_paper" => false,
          "content_type" => "application/pdf",
          "file_size" => 932,
          "filename" => "PUBLIC_1392629965.pdf",
          "number_of_pages" => 2,
          "locale" => "en",
        }],
      },
    }
    setup_and_visit_content_item("publication-with-featured-attachments", overrides)
    within "#documents" do
      assert page.has_text?("Request an accessible format")
    end
  end

  test "doesn't render accessible format option when accessible is false and email is not supplied" do
    overrides = {
      "details" => {
        "attachments" => [{
          "accessible" => false,
          "attachment_type" => "file",
          "id" => "PUBLIC_1392629965.pdf",
          "title" => "Number of ex-regular service personnel now part of FR20",
          "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
          "command_paper_number" => "",
          "hoc_paper_number" => "",
          "isbn" => "",
          "unique_reference" => "",
          "unnumbered_command_paper" => false,
          "unnumbered_hoc_paper" => false,
          "content_type" => "application/pdf",
          "file_size" => 932,
          "filename" => "PUBLIC_1392629965.pdf",
          "number_of_pages" => 2,
          "locale" => "en",
        }],
      },
    }
    setup_and_visit_content_item("publication-with-featured-attachments", overrides)
    within "#documents" do
      assert page.has_no_text?("Request an accessible format")
    end
  end

  test "doesn't render accessible format option when accessible is true and email is supplied" do
    overrides = {
      "details" => {
        "attachments" => [{
          "accessible" => true,
          "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
          "attachment_type" => "file",
          "id" => "PUBLIC_1392629965.pdf",
          "title" => "Number of ex-regular service personnel now part of FR20",
          "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
          "command_paper_number" => "",
          "hoc_paper_number" => "",
          "isbn" => "",
          "unique_reference" => "",
          "unnumbered_command_paper" => false,
          "unnumbered_hoc_paper" => false,
          "content_type" => "application/pdf",
          "file_size" => 932,
          "filename" => "PUBLIC_1392629965.pdf",
          "number_of_pages" => 2,
          "locale" => "en",
        }],
      },
    }
    setup_and_visit_content_item("publication-with-featured-attachments", overrides)
    within "#documents" do
      assert page.has_no_text?("Request an accessible format")
    end
  end

  test "renders external links correctly" do
    overrides = {
      "details" => {
        "attachments" => [{
          "accessible" => true,
          "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
          "attachment_type" => "external",
          "id" => "PUBLIC_1392629965.pdf",
          "title" => "Number of ex-regular service personnel now part of FR20",
          "url" => "https://not-a-real-website-hopefully",
          "command_paper_number" => "",
          "hoc_paper_number" => "",
          "isbn" => "",
          "unique_reference" => "",
          "unnumbered_command_paper" => false,
          "unnumbered_hoc_paper" => false,
          "content_type" => "application/pdf",
          "file_size" => 932,
          "filename" => "PUBLIC_1392629965.pdf",
          "number_of_pages" => 2,
          "locale" => "en",
        }],
      },
    }
    setup_and_visit_content_item("publication-with-featured-attachments", overrides)
    within "#documents" do
      assert page.has_text?("https://not-a-real-website-hopefully")
      assert page.has_no_text?("HTML")
    end
  end

  test "withdrawn publication" do
    setup_and_visit_content_item("withdrawn_publication")
    assert page.has_css?("title", text: "[Withdrawn]", visible: false)

    within ".gem-c-notice" do
      assert page.has_text?("This publication was withdrawn"), "is withdrawn"
      assert page.has_text?("guidance for keepers of sheep, goats and pigs")
      assert page.has_css?("time[datetime='#{@content_item['withdrawn_notice']['withdrawn_at']}']")
    end
  end

  test "historically political publication" do
    setup_and_visit_content_item("political_publication")

    within ".govuk-notification-banner__content" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end

  test "national statistics publication shows a logo" do
    setup_and_visit_content_item("statistics_publication")
    assert page.has_css?('img[alt="National Statistics"]')
  end

  test "national statistics publication has correct structured data" do
    setup_and_visit_content_item("statistics_publication")
    assert_has_structured_data(page, "Dataset")
  end

  test "renders 'Applies to' block in important metadata when there are excluded nations" do
    setup_and_visit_content_item("statistics_publication")
    assert_has_devolved_nations_component("Applies to England", [
      {
        text: "Publication for Northern Ireland",
        alternative_url: "http://www.dsdni.gov.uk/index/stats_and_research/stats-publications/stats-housing-publications/housing_stats.htm",
      },
      {
        text: "Publication for Scotland",
        alternative_url: "http://www.scotland.gov.uk/Topics/Statistics/Browse/Housing-Regeneration/HSfS",
      },
      {
        text: "Publication for Wales",
        alternative_url: "http://wales.gov.uk/topics/statistics/headlines/housing2012/121025/?lang=en",
      },
    ])
  end

  test "renders with the single page notification button" do
    setup_and_visit_content_item("publication")
    assert page.has_css?(".gem-c-single-page-notification-button")

    buttons = page.find_all(:button)

    expected_tracking_top = single_page_notification_button_ga_tracking(1, "Top")
    actual_tracking_top = JSON.parse(buttons.first["data-ga4-link"])
    assert_equal expected_tracking_top, actual_tracking_top

    expected_tracking_bottom = single_page_notification_button_ga_tracking(2, "Footer")
    actual_tracking_bottom = JSON.parse(buttons.last["data-ga4-link"])
    assert_equal expected_tracking_bottom, actual_tracking_bottom
  end

  test "does not render the single page notification button on exempt pages" do
    setup_and_visit_notification_exempt_page("publication")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
