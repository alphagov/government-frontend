module WorldwideOrganisation
  module Branding
    DEFAULT_ORGANISATION_LOGO = "single-identity".freeze

    def organisation_logo
      link_to_organisation = defined?(worldwide_organisation) && worldwide_organisation

      sponsoring_organisation = sponsoring_organisations&.first
      {
        name: formatted_title.html_safe,
        url: link_to_organisation ? worldwide_organisation.base_path : nil,
        crest: sponsoring_organisation&.dig("details", "logo", "crest") || DEFAULT_ORGANISATION_LOGO,
        brand: sponsoring_organisation&.dig("details", "brand") || DEFAULT_ORGANISATION_LOGO,
      }
    end
  end
end
