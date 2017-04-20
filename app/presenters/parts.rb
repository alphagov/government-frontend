module Parts
  def parts
    content_item.dig("details", "parts") || []
  end

  # When requesting a part, the content store will return a content item
  # with a base path that's different to the one requested. That content
  # item contains all the parts for that document.
  def requesting_a_part?
    parts.any? && requested_content_item_path && requested_content_item_path != base_path
  end

  def has_valid_part?
    !!parts.find { |part| part["slug"] == @part_slug }
  end
end
