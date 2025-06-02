class WebchatController < ApplicationController
  def show
    @content_item = WebchatPresenter.new(content_item, request.path, view_context)
    @webchat_config = Webchat.find(request.path)
  rescue ActiveModel::ValidationError, StandardError => e
    Rails.logger.error "Webchat error: #{e.message}"
    render plain: "Webchat configuration not found", status: :not_found
  end

  def service_sign_in_options
    return head :not_found unless content_item_path.include?("sign-in")
  end

  private

  def content_item
    {
      "analytics_identifier" => nil,
      "base_path" => "/government/organisations/hm-passport-office/contact/hm-passport-office-webchat",
      "content_id" => "0d21ce27-83b6-4465-b99a-fcf2124b2238",
      "description" => "Contact the HM Passport Office Webchat service",
      "details" => {
        "contact_form_links" => [],
        "contact_groups" => [],
        "description" => "Contact the HM Passport Office Webchat service",
        "email_addresses" => [],
        "language" => "en",
        "more_info_contact_form" => nil,
        "more_info_email_address" => nil,
        "more_info_phone_number" => nil,
        "more_info_post_address" => nil,
        "more_info_webchat" => "\u003Cp\u003EMonday to Friday, 8am to 8pm \u003Cbr\u003E\nWeekends and public holidays, 9am to 5:30pm\u003C/p\u003E\n\n\u003Cp\u003EAdvisers may be busy at peak times.\u003C/p\u003E\n",
        "phone_numbers" => [],
        "post_addresses" => [],
        "query_response_time" => false,
        "quick_links" => [
          {
            "title" => "Get a passport urgently",
            "url" => "https://www.gov.uk/get-a-passport-urgently"
          },
          {
            "title" => "Passport advice line",
            "url" => "https://www.gov.uk/passport-advice-line"
          }
        ],
        "slug" => "hm-passport-office-webchat",
        "title" => "HM Passport Office webchat"
      },
      "document_type" => "contact",
      "first_published_at" => "2020-11-06T14:31:50+00:00",
      "links" => {
        "available_translations" => [
          {
            "api_path" => "/api/content/government/organisations/hm-passport-office/contact/hm-passport-office-webchat",
            "api_url" => "https://www.gov.uk/api/content/government/organisations/hm-passport-office/contact/hm-passport-office-webchat",
            "base_path" => "/government/organisations/hm-passport-office/contact/hm-passport-office-webchat",
            "content_id" => "0d21ce27-83b6-4465-b99a-fcf2124b2238",
            "document_type" => "contact",
            "links" => {

            },
            "locale" => "en",
            "public_updated_at" => "2020-11-06T14:31:50Z",
            "schema_name" => "contact",
            "title" => "HM Passport Office webchat",
            "web_url" => "https://www.gov.uk/government/organisations/hm-passport-office/contact/hm-passport-office-webchat",
            "withdrawn" => false
          }
        ],
        "organisations" => [
          {
            "analytics_identifier" => "EA66",
            "api_path" => "/api/content/government/organisations/hm-passport-office",
            "api_url" => "https://www.gov.uk/api/content/government/organisations/hm-passport-office",
            "base_path" => "/government/organisations/hm-passport-office",
            "content_id" => "3a96a1e0-21e3-4aae-8e84-f90860ed3dbf",
            "details" => {
              "acronym" => "HM Passport Office",
              "brand" => "home-office",
              "default_news_image" => nil,
              "logo" => {
                "crest" => "ho",
                "formatted_title" => "HM Passport\u003Cbr/\u003EOffice"
              },
              "organisation_govuk_status" => {
                "status" => "live",
                "updated_at" => nil,
                "url" => nil
              }
            },
            "document_type" => "organisation",
            "links" => {

            },
            "locale" => "en",
            "schema_name" => "organisation",
            "title" => "HM Passport Office",
            "web_url" => "https://www.gov.uk/government/organisations/hm-passport-office",
            "withdrawn" => false
          }
        ],
        "parent" => [
          {
            "analytics_identifier" => "EA66",
            "api_path" => "/api/content/government/organisations/hm-passport-office",
            "api_url" => "https://www.gov.uk/api/content/government/organisations/hm-passport-office",
            "base_path" => "/government/organisations/hm-passport-office",
            "content_id" => "3a96a1e0-21e3-4aae-8e84-f90860ed3dbf",
            "details" => {
              "acronym" => "HM Passport Office",
              "brand" => "home-office",
              "default_news_image" => nil,
              "logo" => {
                "crest" => "ho",
                "formatted_title" => "HM Passport\u003Cbr/\u003EOffice"
              },
              "organisation_govuk_status" => {
                "status" => "live",
                "updated_at" => nil,
                "url" => nil
              }
            },
            "document_type" => "organisation",
            "links" => {

            },
            "locale" => "en",
            "schema_name" => "organisation",
            "title" => "HM Passport Office",
            "web_url" => "https://www.gov.uk/government/organisations/hm-passport-office",
            "withdrawn" => false
          }
        ],
        "primary_publishing_organisation" => [
          {
            "analytics_identifier" => "EA66",
            "api_path" => "/api/content/government/organisations/hm-passport-office",
            "api_url" => "https://www.gov.uk/api/content/government/organisations/hm-passport-office",
            "base_path" => "/government/organisations/hm-passport-office",
            "content_id" => "3a96a1e0-21e3-4aae-8e84-f90860ed3dbf",
            "details" => {
              "acronym" => "HM Passport Office",
              "brand" => "home-office",
              "default_news_image" => nil,
              "logo" => {
                "crest" => "ho",
                "formatted_title" => "HM Passport\u003Cbr/\u003EOffice"
              },
              "organisation_govuk_status" => {
                "status" => "live",
                "updated_at" => nil,
                "url" => nil
              }
            },
            "document_type" => "organisation",
            "links" => {

            },
            "locale" => "en",
            "schema_name" => "organisation",
            "title" => "HM Passport Office",
            "web_url" => "https://www.gov.uk/government/organisations/hm-passport-office",
            "withdrawn" => false
          }
        ]
      },
      "locale" => "en",
      "phase" => "live",
      "public_updated_at" => "2020-11-06T14:31:50+00:00",
      "publishing_app" => "contacts",
      "publishing_request_id" => "20-1744712580.996-10.13.31.8-703",
      "publishing_scheduled_at" => nil,
      "rendering_app" => "government-frontend",
      "scheduled_publishing_delay_seconds" => nil,
      "schema_name" => "contact",
      "title" => "HM Passport Office webchat",
      "updated_at" => "2025-04-15T11:23:01+01:00",
      "withdrawn_notice" => {}
    }
  end
end
