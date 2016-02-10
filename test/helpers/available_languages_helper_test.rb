require 'test_helper'

class AvailableLanguagesHelperTest < ActionView::TestCase
  test "native_language_name_for returns native locale names" do
    locales = %w(en es ar).map { |l| native_language_name_for(l) }
    assert_equal %w(English Español العربية), locales
  end
end
