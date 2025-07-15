module DateTimeHelper
  def self.display_date(timestamp, locale: I18n.locale, format: "%-d %B %Y")
    I18n.l(Time.zone.parse(timestamp), format:, locale:) if timestamp
  end

  def self.display_date_and_time(date, rollback_midnight: false)
    time = Time.zone.parse(date)
    date_format = "%-e %B %Y"
    time_format = "%l:%M%P"

    if rollback_midnight && (time.strftime(time_format) == "12:00am")
      # 12am, 12:00am and "midnight on" can all be misinterpreted
      # Use 11:59pm on the day before to remove ambiguity
      # 12am on 10 January becomes 11:59pm on 9 January
      time -= 1.second
    end
    I18n.l(time, format: "#{time_format} #{I18n.t('consultation.on')} #{date_format}").gsub(":00", "").gsub("12pm", "midday").gsub("12am #{I18n.t('consultation.on')} ", "").strip
  end
end
