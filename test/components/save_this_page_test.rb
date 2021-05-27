require "component_test_helper"

class SaveThisPageTest < ComponentTestCase
  def component_name
    "save_this_page"
  end

  test "does not render without page path" do
    assert_empty render_component({})
    assert_empty render_component(
      signed_in: true,
      page_is_saved: true,
    )
  end

  test "renders signed out state by default" do
    render_component(page_path: "/test")
    assert_select ".app-c-save-this-page a.govuk-button", text: "Add to your saved pages", href: "/account/saved-pages/add?page_path=/test"
    assert_select ".app-c-save-this-page .govuk-link", text: "Sign in"
  end

  test "renders signed out state when signed_in is false" do
    render_component(
      page_path: "/test",
      signed_in: false,
    )
    assert_select ".app-c-save-this-page a.govuk-button", text: "Add to your saved pages", href: "/account/saved-pages/add?page_path=/test"
    assert_select ".app-c-save-this-page .govuk-link", text: "Sign in"
  end

  test "renders signed in state with 'save this page' option" do
    render_component(
      page_path: "/test",
      signed_in: true,
    )
    assert_select ".app-c-save-this-page a.govuk-button", text: "Add to your saved pages", href: "/account/saved-pages/add?page_path=/test"
    assert_select ".app-c-save-this-page .govuk-link", text: "See your saved pages"
  end

  test "renders with 'remove this page' option if page has already been saved" do
    render_component(
      page_path: "/test",
      signed_in: true,
      page_is_saved: true,
    )
    assert_select ".app-c-save-this-page a.govuk-button", text: "Remove from your saved pages", href: "/account/saved-pages/remove?page_path=/test"
    assert_select ".app-c-save-this-page .govuk-link", text: "See your saved pages"
  end
end
