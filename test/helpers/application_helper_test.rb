require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  tests ApplicationHelper

  test "#current_path_without_query_string returns the path of the current request" do
    self.stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => "/foo/bar"))
    assert_equal "/foo/bar", current_path_without_query_string
  end

  test "#current_path_without_query_string returns the path of the current request stripping off any query string parameters" do
    self.stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => "/foo/bar", "QUERY_STRING" => "ham=jam&spam=gram"))
    assert_equal "/foo/bar", current_path_without_query_string
  end

  test "#t_locale_fallback returns nil for a string with a locale translation" do
    fallback = t_locale_fallback("content_item.schema_name.imported", count: 1, locale: :de)
    assert_nil fallback
  end

  test "#t_locale_fallback returns default locale for a string with no locale translation" do
    I18n.with_locale(:de) do
      fallback = t_locale_fallback("content_item.schema_name.decision", count: 1, locale: :de)
      assert_equal :en, fallback
    end
  end

  test "#t_locale_fallback returns fallback for irrelevant key" do
    I18n.with_locale(:de) do
      fallback = t_locale_fallback("blah", count: 1)
      assert_equal :en, fallback
    end
  end
end
