module WebchatProviders
  class Egain
    def initialize(base_path)
      @base_path = base_path
    end

    def webchat_ids
      {
        "/government/organisations/hm-revenue-customs/contact/child-benefit" => 1027,
        "/government/organisations/hm-revenue-customs/contact/income-tax-enquiries-for-individuals-pensioners-and-employees" => 1030,
        "/government/organisations/hm-revenue-customs/contact/vat-online-services-helpdesk" => 1026,
        "/government/organisations/hm-revenue-customs/contact/national-insurance-numbers" => 1021,
        "/government/organisations/hm-revenue-customs/contact/self-assessment" => 1004,
        "/government/organisations/hm-revenue-customs/contact/tax-credits-enquiries" => 1016,
        "/government/organisations/hm-revenue-customs/contact/vat-enquiries" => 1028,
        "/government/organisations/hm-revenue-customs/contact/customs-international-trade-and-excise-enquiries" => 1034,
        "/government/organisations/hm-revenue-customs/contact/employer-enquiries" => 1023,
        "/government/organisations/hm-revenue-customs/contact/online-services-helpdesk" => 1003,
        "/government/organisations/hm-revenue-customs/contact/charities-and-community-amateur-sports-clubs-cascs" => 1087,
        "/government/organisations/hm-revenue-customs/contact/enquiries-from-employers-with-expatriate-employees" => 1089,
        "/government/organisations/hm-revenue-customs/contact/share-schemes-for-employees" => 1088,
        "/government/organisations/hm-revenue-customs/contact/non-uk-expatriate-employees-expats" => 1089,
        "/government/organisations/hm-revenue-customs/contact/non-resident-landlords" => 1086,
      }
    end

    def webchat_id
      webchat_ids[@base_path].presence
    end

    def availability_url
      "https://www.tax.service.gov.uk/csp-partials/availability/#{webchat_id}"
    end

    def open_url
      "https://www.tax.service.gov.uk/csp-partials/open/#{webchat_id}"
    end

    def config
      {
        "open-url": open_url,
        "availability-url": availability_url,
      }
    end
  end
end
