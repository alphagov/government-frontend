module WebchatAvailabilityHelper
  UNAVAILABILITY_MESSAGE = "This service will be unavailable from 4pm on Saturday 12 May to 9am on Monday 14 May.".freeze
  HMRC_WEBCHAT_CONTACT_PATHS = %w(
    /government/organisations/hm-revenue-customs/contact/online-services-helpdesk
    /government/organisations/hm-revenue-customs/contact/income-tax-enquiries-for-individuals-pensioners-and-employees
    /government/organisations/hm-revenue-customs/contact/self-assessment
    /government/organisations/hm-revenue-customs/contact/tax-credits-enquiries
  ).freeze
  UNAVAILABILITY_START = Time.zone.parse("2018-05-12 16:00 BST").freeze
  UNAVAILABILITY_END = Time.zone.parse("2018-05-14 09:00 BST").freeze

  def webchat_unavailable?(now = Time.zone.now)
    show_unavailability = now >= UNAVAILABILITY_START && now < UNAVAILABILITY_END
    show_unavailability && HMRC_WEBCHAT_CONTACT_PATHS.include?(@content_item.base_path)
  end

  def unavailability_message
    UNAVAILABILITY_MESSAGE
  end
end
