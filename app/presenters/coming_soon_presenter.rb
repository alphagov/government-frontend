class ComingSoonPresenter < ContentItemPresenter
  attr_reader :publish_time

  def initialize(content_item, requested_content_item_path = nil)
    super
    @publish_time = content_item["details"]["publish_time"]
  end

  def iso8601_publish_time
    @publish_time # This will be iso8601 because it's a JSON datetime
  end

  def formatted_publish_date
    display_date(@publish_time.to_date)
  end

  def formatted_publish_time
    display_time(DateTime.parse(@publish_time))
  end

private

  def display_date(date)
    date.strftime("%e %B %Y")
  end

  def display_time(timestamp)
    timestamp.strftime("%H:%M")
  end
end
