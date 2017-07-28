require 'component_test_helper'

class TranslationNavTest < ComponentTestCase
  def component_name
    "translation-nav"
  end

  test "fails to render a translation nav when no translations are given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders an active translation nav item with only text description" do
    render_component(
      translations: [
        {
          locale: 'en',
          base_path: '/en',
          text: 'English',
          active: true
        }
      ]
    )

    assert_select ".app-c-translation-nav__list__language", text: "English"
    assert_select ".app-c-translation-nav__list__language a[href=\"/en\"]",
                    false, "An active item should not link to a page translation"
  end

  test "renders an inactive translation nav item with href, base path and text" do
    render_component(
      translations: [
        {
          locale: 'fr',
          base_path: '/fr',
          text: 'French'
        }
      ]
    )

    assert_select ".app-c-translation-nav__list__language a[lang=\"fr\"]", text: "French"
    assert_select ".app-c-translation-nav__list__language a[href=\"/fr\"]"
  end
end
