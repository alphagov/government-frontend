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

  test "renders an active translation nav item with a text description" do
    render_component(translations: multiple_translations)

    assert_select ".app-c-translation-nav__list-item", text: "English"

    assert_select ".app-c-translation-nav__list-item a[lang=\"hi\"]", text: "हिंदी"
    assert_select ".app-c-translation-nav__list-item a[href=\"/hi\"]"
  end

  test "identifies the language of the text" do
    render_component(translations: multiple_translations)
    assert_select "span[lang='en']", text: "English"
    assert_select "a[lang='hi']", text: "हिंदी"
  end

  test "does not render an active translation item with a link" do
    render_component(translations: multiple_translations)

    assert_select ".app-c-translation-nav__list-item", text: "English"
    assert_select ".app-c-translation-nav__list-item a[href=\"/en\"]",
      false, "An active item should not link to a page translation"


    assert_select ".app-c-translation-nav__list-item a[lang=\"hi\"]", text: "हिंदी"
    assert_select ".app-c-translation-nav__list-item a[href=\"/hi\"]"
  end

  test "renders an inactive translation nav item with locale, base path and text" do
    render_component(
      translations: [
        {
          locale: 'fr',
          base_path: '/fr',
          text: 'French',
        },
        {
          locale: 'hi',
          base_path: '/hi',
          text: 'हिंदी',
          active: true
        },
        {
          locale: 'zh',
          base_path: '/zh',
          text: '中文'
        }
      ]
    )

    assert_select ".app-c-translation-nav__list-item a[lang=\"fr\"]", text: "French"
    assert_select ".app-c-translation-nav__list-item a[href=\"/fr\"]"

    assert_select ".app-c-translation-nav__list-item a[lang=\"zh\"]", text: "中文"
    assert_select ".app-c-translation-nav__list-item a[href=\"/zh\"]"

    assert_select ".app-c-translation-nav__list-item", text: "हिंदी"
    assert_select ".app-c-translation-nav__list-item a[href=\"/hi\"]",
      false, "An active item should not link to a page translation"
  end
end
