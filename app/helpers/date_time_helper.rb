module DateTimeHelper
  def self.display_date(timestamp, locale: I18n.locale, format: "%-d %B %Y")
    I18n.l(Time.zone.parse(timestamp), format:, locale:) if timestamp
  end
end
