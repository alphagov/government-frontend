require "test_helper"

class PublicationTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    assert_nothing_raised { setup_and_visit_random_content_item(document_type: "statutory_guidance") }
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
    }, context_selector: ".metadata-column")

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
          "content_type" => "application/pdf",
          "filename" => "veolia-permit.pdf",
          "id" => "violia-permit",
          "locale" => "en",
          "title" => "Permit: Veolia ES (UK) Limited",
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
          "content_type" => "application/pdf",
          "filename" => "PUBLIC_1392629965.pdf",
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
          "content_type" => "application/pdf",
          "filename" => "PUBLIC_1392629965.pdf",
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
          "content_type" => "application/pdf",
          "filename" => "PUBLIC_1392629965.pdf",
          "locale" => "en",
        }],
      },
    }
    setup_and_visit_content_item("publication-with-featured-attachments", overrides)
    within "#documents" do
      assert page.has_no_text?("Request an accessible format")
    end
  end

  test "tracks details elements in attachments correctly" do
    overrides = {
      "details" => {
        "attachments" => [
          {
            "accessible" => false,
            "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
            "id" => "PUBLIC_1392629965.pdf",
            "title" => "Attachment 1 - should have details element",
            "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
            "content_type" => "application/pdf",
            "filename" => "PUBLIC_1392629965.pdf",
            "locale" => "en",
          },
          {
            "accessible" => true,
            "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
            "id" => "PUBLIC_1392629965.pdf",
            "title" => "Attachment 2",
            "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
            "content_type" => "application/pdf",
            "filename" => "PUBLIC_1392629965.pdf",
            "locale" => "en",
          },
          {
            "accessible" => true,
            "alternative_format_contact_email" => nil,
            "id" => "PUBLIC_1392629965.pdf",
            "title" => "Attachment 3",
            "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
            "content_type" => "application/pdf",
            "filename" => "PUBLIC_1392629965.pdf",
            "locale" => "en",
          },
          {
            "accessible" => false,
            "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
            "id" => "PUBLIC_1392629965.pdf",
            "title" => "Attachment 4 - should have details element",
            "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
            "content_type" => "application/pdf",
            "filename" => "PUBLIC_1392629965.pdf",
            "locale" => "en",
          },
        ],
      },
    }
    setup_and_visit_content_item("publication-with-featured-attachments", overrides)
    within "#documents" do
      attachments = page.find_all(".gem-c-attachment")
      assert_equal attachments.length, overrides["details"]["attachments"].length

      attachments.each do |attachment|
        next unless attachment.has_css?(".govuk-details__summary")

        details = attachment.find("details")["data-ga4-event"]
        actual_tracking = JSON.parse(details)
        assert_equal actual_tracking["index_section_count"], 2
      end
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
          "content_type" => "application/pdf",
          "filename" => "PUBLIC_1392629965.pdf",
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
    assert page.has_css?('img[alt="Accredited official statistics"]')
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

  test "renders with the single page notification button on English language pages" do
    setup_and_visit_content_item("publication")
    assert page.has_css?(".gem-c-single-page-notification-button")

    buttons = page.find_all("button[data-ga4-link]")

    expected_tracking_top = single_page_notification_button_ga4_tracking(1, "Top")
    actual_tracking_top = JSON.parse(buttons.first["data-ga4-link"])
    assert_equal expected_tracking_top, actual_tracking_top

    expected_tracking_bottom = single_page_notification_button_ga4_tracking(2, "Footer")
    actual_tracking_bottom = JSON.parse(buttons.last["data-ga4-link"])
    assert_equal expected_tracking_bottom, actual_tracking_bottom
  end

  test "does not render the single page notification button on foreign language pages" do
    setup_and_visit_content_item("publication", "locale" => "cy")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end

  test "adds the noindex meta tag to '/government/publications/pension-credit-claim-form--2'" do
    overrides = { "base_path" => "/government/publications/pension-credit-claim-form--2" }
    setup_and_visit_content_item("publication-with-featured-attachments", overrides)
    assert page.has_css?('meta[name="robots"][content="noindex"]', visible: false)
  end

  test "adds the noindex meta tag to mobile paths" do
    mobile_paths = %w[
      /government/publications/govuk-app-terms-and-conditions
      /government/publications/govuk-app-privacy-notice-how-we-use-your-data
      /government/publications/govuk-app-testing-privacy-notice-how-we-use-your-data
      /government/publications/accessibility-statement-for-the-govuk-app
    ]
    mobile_paths.each do |path|
      overrides = { "base_path" => path }
      setup_and_visit_content_item("publication-with-featured-attachments", overrides)
      assert page.has_css?('meta[name="robots"][content="noindex"]', visible: false)
    end
  end

  test "translates Welsh published date correctly" do
    setup_and_visit_content_item("publication", { "locale" => "cy" })

    assert_has_metadata({
      published: "3 Mai 2016",
      from: {
        "Environment Agency": "/government/organisations/environment-agency",
        "The Rt Hon Sir Eric Pickles MP": "/government/people/eric-pickles",
      },
    })

    assert_footer_has_published_dates("Cyhoeddwyd ar 3 Mai 2016")
  end
end
