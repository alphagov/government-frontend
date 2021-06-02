module SaveThisPageHelper
  attr_reader :page_is_saved, :signed_in, :page_path

  PAGE_IS_SAVED_LINK_HREF = {
    true => "#{Plek.new.website_root}/account/saved-pages/remove?page_path=",
    false => "#{Plek.new.website_root}/account/saved-pages/add?page_path=",
  }.freeze

  SEE_SAVED_PAGES_LOGGED_IN = {
    true => "components.save_this_page.see_saved_pages_signed_in",
    false => "components.save_this_page.see_saved_pages_signed_out",
  }.freeze

  def heading_text(options)
    options[:page_is_saved] ? I18n.t("components.save_this_page.page_was_saved_heading") : I18n.t("components.save_this_page.page_not_saved_heading")
  end

  def link_text(options)
    options[:page_is_saved] ? I18n.t("components.save_this_page.remove_page_button") : I18n.t("components.save_this_page.add_page_button")
  end

  def link_href(options)
    page_is_saved = options[:page_is_saved] || false
    page_path = options[:page_path] || ""
    PAGE_IS_SAVED_LINK_HREF[page_is_saved] + page_path
  end

  def additional_text(options)
    signed_in = options[:signed_in] || false
    I18n.t(SEE_SAVED_PAGES_LOGGED_IN[signed_in], link: "#{Plek.new.website_root}/account/saved-pages", additional_class: options[:additional_class])
  end
end
