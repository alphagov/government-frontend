module ManualsHelper
  def sanitize_manual_update_title(title)
    return "" if title.nil?

    strip_tags(title).gsub(I18n.t("manuals.updates_amendments"), "").gsub(/\s+/, " ").strip
  end
end
