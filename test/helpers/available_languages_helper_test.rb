require 'test_helper'

class AvailableLanguagesHelperTest < ActionView::TestCase
  test "native_language_name_for returns native locale names" do
    locales = ['en', 'es', 'ar'].map {|l| native_language_name_for(l)}
    assert_equal ["English", "Español", "العربية"], locales
  end
end
