require "test_helper"

class SaveThisPageHelperTest < ActionView::TestCase
  test "displays correctly by default" do
    params = { page_path: "/test" }
    has_save_this_page_button(params)
    has_page_not_saved_heading(params)
    has_signed_out_additional_text(params)
  end

  test "displays correctly when user is signed out" do
    params = { page_path: "/test", signed_in: false }
    has_save_this_page_button(params)
    has_page_not_saved_heading(params)
    has_signed_out_additional_text(params)
  end

  test "displays correctly when user is signed in and has not saved the page" do
    params = { page_path: "/test", signed_in: true, page_is_saved: false }
    has_save_this_page_button(params)
    has_page_not_saved_heading(params)
    has_signed_in_additional_text(params)
  end

  test "displays correctly when user is signed in and has already saved the page" do
    params = { page_path: "/test", signed_in: true, page_is_saved: true }
    has_remove_this_page_button(params)
    has_page_was_saved_heading(params)
    has_signed_in_additional_text(params)
  end

  def has_save_this_page_button(params)
    assert_equal I18n.t("components.save_this_page.add_page_button"), link_text(params)
    assert_equal "/account/saved-pages/add?page_path=/test", link_href(params)
  end

  def has_remove_this_page_button(params)
    assert_equal I18n.t("components.save_this_page.remove_page_button"), link_text(params)
    assert_equal "/account/saved-pages/remove?page_path=/test", link_href(params)
  end

  def has_page_not_saved_heading(params)
    assert_equal I18n.t("components.save_this_page.page_not_saved_heading"), heading_text(params)
  end

  def has_page_was_saved_heading(params)
    assert_equal I18n.t("components.save_this_page.page_was_saved_heading"), heading_text(params)
  end

  def has_signed_in_additional_text(params)
    assert_equal I18n.t("components.save_this_page.see_saved_pages_signed_in", link: "/account/saved-pages"), additional_text(params)
  end

  def has_signed_out_additional_text(params)
    assert_equal I18n.t("components.save_this_page.see_saved_pages_signed_out", link: "/account/saved-pages"), additional_text(params)
  end
end
