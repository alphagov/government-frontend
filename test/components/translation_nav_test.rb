require 'component_test_helper'

class TranslationNavTest < ComponentTestCase
  def component_name
    "translation-nav"
  end

  def multiple_translations
    [
      {
        locale: 'en',
        base_path: '/en',
        text: 'English',
        active: true
      },
      {
        locale: 'hi',
        base_path: '/hi',
        text: 'हिंदी',
      }
    ]
  end

  test "renders nothing when no translations are given" do
    assert_empty render_component({})
  end

  test "renders nothing when only one translation given" do
    assert_empty render_component(
      translations: [
        {
          locale: 'en',
          base_path: '/en',
          text: 'English',
          active: true
        }
      ]
    )
  end

  test "renders all items in a list" do
    render_component(translations: multiple_translations)
    assert_select ".app-c-translation-nav__list-item", count: multiple_translations.length
  end

  test "renders an active item as text without a link" do
    render_component(translations: multiple_translations)
    assert_select ".app-c-translation-nav__list-item :not(a)", text: "English"
    assert_select "a[href=\"/en\"]", false, "An active item should not be a link"
  end

  test "renders inactive items as a link with locale, base path and text" do
    render_component(translations: multiple_translations)
    assert_select ".app-c-translation-nav__list-item a[lang='hi'][href='/hi']", text: "हिंदी"
  end

  test "identifies the language of the text" do
    render_component(translations: multiple_translations)
    assert_select "span[lang='en']", text: "English"
    assert_select "a[lang='hi']", text: "हिंदी"
  end
end
