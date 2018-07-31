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
end
