module Updatable
  def published
    display_date(content_item["details"]["first_public_at"])
  end

  def updated
    display_date(content_item["public_updated_at"]) if any_updates?
  end

  def history
    return [] unless any_updates?
    return [] unless content_item["details"]["change_history"].present?

    content_item["details"]["change_history"].map do |item|
      {
        display_time: display_date(item["public_timestamp"]),
        note: item["note"],
        timestamp: item["public_timestamp"]
      }
    end
  end

private

  def any_updates?
    if (first_public_at = content_item["details"]["first_public_at"]).present?
      DateTime.parse(content_item["public_updated_at"]) != DateTime.parse(first_public_at)
    else
      false
    end
  end
end
