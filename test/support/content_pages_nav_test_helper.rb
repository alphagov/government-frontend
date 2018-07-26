module ContentPagesNavTestHelper
  def stub_rummager
    stub_any_rummager_search
          .to_return(
            body: {
              "results": [
                {
                  "content_store_document_type": "form",
                  "description": "This agreement must be signed by the apprentice and the employer at the start of the apprenticeship.",
                  "link": "/government/publications/apprenticeship-agreement-template",
                  "public_timestamp": "2012-08-28T00:00:00.000+01:00",
                  "title": "Apprenticeship agreement: template",
                  "index": "government",
                  "_id": "/government/publications/apprenticeship-agreement-template",
                  "elasticsearch_type": "edition",
                  "document_type": "edition"
                }
              ],
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
