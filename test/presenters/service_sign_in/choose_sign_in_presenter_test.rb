require 'test_helper'

class ServiceSignInPresenterTest
  class ChooseSignIn < ActiveSupport::TestCase
    def schema_name
      "service_sign_in"
    end

    def setup
      @presented_item = present_example(schema_item)
    end

    def present_example(example)
      ServiceSignIn::ChooseSignInPresenter.new(example)
    end

    def schema_item
      @schema_item ||= govuk_content_schema_example(schema_name, schema_name)
    end

    test 'presents the schema_name' do
      assert_equal schema_item['schema_name'], @presented_item.schema_name
    end
  end
end
