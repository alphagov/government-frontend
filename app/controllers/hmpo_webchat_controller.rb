# Temporary controller to host the HMPO webchat contact page.
# This is because contact admin is retired, and we currently do not
# support the webchat configuration in the new publisher (Specialist Publisher).
# Storing this here for now to enable contact admin retirement
# until we can port it over to the new publisher.
class HmpoWebchatController < ContentItemsController
  def hmpo_webchat
    @content_item = ContactPresenter.new(
      HmpoWebchatContentItem.new,
      content_item_path,
      view_context,
    )

    render "content_items/contact"
  end

  class HmpoWebchatContentItem < Hash
    def initialize
      super
      merge!({
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
          "more_info_webchat" => "<p>Monday to Friday, 8am to 8pm <br>\nWeekends and public holidays, 9am to 5:30pm</p>\n\n<p>Advisers may be busy at peak times.</p>\n",
          "phone_numbers" => [],
          "post_addresses" => [],
          "query_response_time" => false,
          "quick_links" => [
            {
              "title" => "Get a passport urgently",
              "url" => "#{Plek.new.website_root}/get-a-passport-urgently",
            },
            {
              "title" => "Passport advice line",
              "url" => "#{Plek.new.website_root}/passport-advice-line",
            },
          ],
          "slug" => "hm-passport-office-webchat",
          "title" => "HM Passport Office webchat",
        },
        "document_type" => "contact",
        "first_published_at" => "2020-11-06T14:31:50+00:00",
        "links" => {
          "available_translations" => [
            {
              "api_path" => "/api/content/government/organisations/hm-passport-office/contact/hm-passport-office-webchat",
              "api_url" => "#{Plek.new.website_root}/api/content/government/organisations/hm-passport-office/contact/hm-passport-office-webchat",
              "base_path" => "/government/organisations/hm-passport-office/contact/hm-passport-office-webchat",
              "content_id" => "0d21ce27-83b6-4465-b99a-fcf2124b2238",
              "document_type" => "contact",
              "links" => {},
              "locale" => "en",
              "public_updated_at" => "2020-11-06T14:31:50Z",
              "schema_name" => "contact",
              "title" => "HM Passport Office webchat",
              "web_url" => "#{Plek.new.website_root}/government/organisations/hm-passport-office/contact/hm-passport-office-webchat",
              "withdrawn" => false,
            },
          ],
          "organisations" => [
            {
              "analytics_identifier" => "EA66",
              "api_path" => "/api/content/government/organisations/hm-passport-office",
              "api_url" => "#{Plek.new.website_root}/api/content/government/organisations/hm-passport-office",
              "base_path" => "/government/organisations/hm-passport-office",
              "content_id" => "3a96a1e0-21e3-4aae-8e84-f90860ed3dbf",
              "details" => {
                "acronym" => "HM Passport Office",
                "brand" => "home-office",
                "default_news_image" => nil,
                "logo" => {
                  "crest" => "ho",
                  "formatted_title" => "HM Passport<br/>Office",
                },
                "organisation_govuk_status" => {
                  "status" => "live",
                  "updated_at" => nil,
                  "url" => nil,
                },
              },
              "document_type" => "organisation",
              "links" => {},
              "locale" => "en",
              "schema_name" => "organisation",
              "title" => "HM Passport Office",
              "web_url" => "#{Plek.new.website_root}/government/organisations/hm-passport-office",
              "withdrawn" => false,
            },
          ],
          "parent" => [
            {
              "analytics_identifier" => "EA66",
              "api_path" => "/api/content/government/organisations/hm-passport-office",
              "api_url" => "#{Plek.new.website_root}/api/content/government/organisations/hm-passport-office",
              "base_path" => "/government/organisations/hm-passport-office",
              "content_id" => "3a96a1e0-21e3-4aae-8e84-f90860ed3dbf",
              "details" => {
                "acronym" => "HM Passport Office",
                "brand" => "home-office",
                "default_news_image" => nil,
                "logo" => {
                  "crest" => "ho",
                  "formatted_title" => "HM Passport<br/>Office",
                },
                "organisation_govuk_status" => {
                  "status" => "live",
                  "updated_at" => nil,
                  "url" => nil,
                },
              },
              "document_type" => "organisation",
              "links" => {},
              "locale" => "en",
              "schema_name" => "organisation",
              "title" => "HM Passport Office",
              "web_url" => "#{Plek.new.website_root}/government/organisations/hm-passport-office",
              "withdrawn" => false,
            },
          ],
          "primary_publishing_organisation" => [
            {
              "analytics_identifier" => "EA66",
              "api_path" => "/api/content/government/organisations/hm-passport-office",
              "api_url" => "#{Plek.new.website_root}/api/content/government/organisations/hm-passport-office",
              "base_path" => "/government/organisations/hm-passport-office",
              "content_id" => "3a96a1e0-21e3-4aae-8e84-f90860ed3dbf",
              "details" => {
                "acronym" => "HM Passport Office",
                "brand" => "home-office",
                "default_news_image" => nil,
                "logo" => {
                  "crest" => "ho",
                  "formatted_title" => "HM Passport<br/>Office",
                },
                "organisation_govuk_status" => {
                  "status" => "live",
                  "updated_at" => nil,
                  "url" => nil,
                },
              },
              "document_type" => "organisation",
              "links" => {},
              "locale" => "en",
              "schema_name" => "organisation",
              "title" => "HM Passport Office",
              "web_url" => "#{Plek.new.website_root}/government/organisations/hm-passport-office",
              "withdrawn" => false,
            },
          ],
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
        "withdrawn_notice" => {},
      })
    end

    def parsed_content
      self
    end
  end
end
