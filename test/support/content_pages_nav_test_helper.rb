module ContentPagesNavTestHelper
  def stub_rummager
    results = []

    4.times do
      results.push(
        "content_store_document_type": "form",
        "link": "/government/publications/meals",
        "title": "Free school meals form",
      )
    end

    stub_any_rummager_search.to_return(
      body: {
        "results": results,
        "total": 1,
        "start": 0,
        "aggregates": {},
        "suggested_queries": []
      }.to_json
    )

    content_store_has_item('/government/publications/meals')
  end

  def stub_empty_rummager
    results = []

    stub_any_rummager_search.to_return(
      body: {
        "results": results,
        "total": 1,
        "start": 0,
        "aggregates": {},
        "suggested_queries": []
      }.to_json
    )
  end

  def setup_and_visit_content_from_publishing_app(publishing_app: nil)
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: schema_type) do |payload|
      payload.merge('publishing_app' => publishing_app) unless publishing_app.nil?
      payload
    end

    content_id = content_item["content_id"]
    path = content_item["base_path"]

    stub_request(:get, %r{#{path}})
        .to_return(status: 200, body: content_item.to_json, headers: {})
    visit path

    assert_selector %{meta[name="govuk:content-id"][content="#{content_id}"}, visible: false
  end

  SINGLE_TAXON = [
    {
      "base_path" => "/education/becoming-an-apprentice",
      "content_id" => "ff0e8e1f-4dea-42ff-b1d5-f1ae37807af2",
      "description" => "Pay and conditions, how to apply, become a higher or degree apprentice. Apprenticeship levels, training, find an apprenticeship.",
      "schema_name" => "taxon",
      "title" => "Becoming an apprentice",
      "phase" => "live",
    }
  ].freeze

  THREE_TAXONS = [
    {
      "base_path" => "/education/becoming-an-apprentice",
      "content_id" => "ff0e8e1f-4dea-42ff-b1d5-f1ae37807af2",
      "description" => "Pay and conditions, how to apply, become a higher or degree apprentice. Apprenticeship levels, training, find an apprenticeship.",
      "schema_name" => "taxon",
      "title" => "Becoming an apprentice",
      "phase" => "live",
    },
    {
      "base_path" => "/education/becoming-a-wizard",
      "content_id" => "ff0e8e1f-4dea-42ff-b1d5-f1ae37807af3",
      "description" => "Pay and conditions, how to apply, become a higher or degree wizard. Wizard levels, training, find a wizard placement.",
      "schema_name" => "taxon",
      "title" => "Becoming a wizard",
      "phase" => "live",
    },
    {
      "base_path" => "/education/becoming-the-sorceror-supreme",
      "content_id" => "ff0e8e1f-4dea-42ff-b1d5-f1ae37807af4",
      "description" => "Pay and conditions, how to apply. The astral plane, the mirror dimension, infinity stones.",
      "schema_name" => "taxon",
      "title" => "Becoming the sorceror supreme",
      "phase" => "live",
    }
  ].freeze

  SINGLE_NON_LIVE_TAXON = [
    {
      "base_path" => "/education/becoming-a-ghostbuster",
      "content_id" => "ff0e8e1f-4dea-42ff-b1d5-f1ae37807af5",
      "description" => "Pay and conditions, how to apply, use of a proton accelerator.",
      "schema_name" => "taxon",
      "title" => "Becoming a ghostbuster",
      "phase" => "ethereal",
    }
  ].freeze

  def stub_links_out_supergroups(supergroups_to_include)
    ContentItemPresenter.any_instance.stubs(:links_out_supergroups).returns(supergroups_to_include)
  end

  def stub_links_out_supergroups_to_include_all
    stub_links_out_supergroups(supergroups)
  end

  def supergroups
    %w(services guidance_and_regulation news_and_communications policy_and_engagement transparency)
  end

  def assert_has_services_section
    assert page.has_css?('h3', text: "Services")
    assert page.has_css?('.gem-c-highlight-boxes__title', text: 'Free school meals form')
    assert page.has_css?('.gem-c-highlight-boxes__title[data-track-category="ServicesHighlightBoxClicked"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-highlight-boxes__title[data-track-action="1"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-highlight-boxes__title[data-track-label="/government/publications/meals"]', text: 'Free school meals form')

    assert page.has_css?('.gem-c-document-list__item a[data-track-category="ServicesDocumentListClicked"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-action="1"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-label="/government/publications/meals"]', text: 'Free school meals form')
  end

  def assert_has_policy_and_engagement_section
    assert page.has_css?('h3', text: "Policy and engagement")

    assert page.has_css?('.gem-c-document-list__item a[data-track-category="policyAndEngagementDocumentListClicked"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-action="1"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-label="/government/publications/meals"]', text: 'Free school meals form')
  end

  def assert_has_guidance_and_regulation_section
    assert page.has_css?('h3', text: "Guidance and regulation")

    assert page.has_css?('.gem-c-document-list__item a[data-track-category="guidanceAndRegulationDocumentListClicked"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-action="1"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-label="/government/publications/meals"]', text: 'Free school meals form')
  end

  def assert_has_transparency_section
    assert page.has_css?('h3', text: "Transparency")

    assert page.has_css?('.gem-c-document-list__item a[data-track-category="transparencyDocumentListClicked"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-action="1"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-label="/government/publications/meals"]', text: 'Free school meals form')
  end

  def assert_has_news_and_communications_section
    assert page.has_css?('h3', text: "News and communications")
    assert page.has_css?('.gem-c-image-card__title', text: 'Free school meals form')
    assert page.has_css?('.gem-c-image-card__title-link[data-track-category="newsAndCommunicationsImageCardClicked"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-image-card__title-link[data-track-action="1"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-image-card__title-link[data-track-label="/government/publications/meals"]', text: 'Free school meals form')

    assert page.has_css?('.gem-c-document-list__item a[data-track-category="newsAndCommunicationsDocumentListClicked"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-action="1"]', text: 'Free school meals form')
    assert page.has_css?('.gem-c-document-list__item a[data-track-label="/government/publications/meals"]', text: 'Free school meals form')
  end
end
