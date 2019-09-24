module StatisticsAnnouncementHelper
  def on_in_between_for_release_date(date)
    return "on #{date}" if date_is_exact_format?(date)
    return "in #{date}" if date_is_one_month_format?(date)
    return "between #{replace_on_with_and(date)}" if date_is_two_month_format?(date)

    date
  end

private

  def replace_on_with_and(date_in_two_month_format)
    re = /\s(to)\s/
    date_in_two_month_format.sub(re, " and ")
  end

  def date_is_two_month_format?(date)
    date =~ /\A(\w+)\s(to)\s(\w+)/
  end

  def date_is_one_month_format?(date)
    date =~ /\A(\w+)\s(\d{1,4})/
  end

  def date_is_exact_format?(date)
    date.downcase =~ /\A(\d{1,2})\s(\w+)\s(\d{4})\s(\d{1,2}:\d{1,2})(am|pm)/
  end
end
