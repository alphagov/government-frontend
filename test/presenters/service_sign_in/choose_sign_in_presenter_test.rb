require 'test_helper'

class ServiceSignInPresenterTest
  class ChooseSignIn < ActiveSupport::TestCase
    def schema_name
      "service_sign_in"
    end

    def setup
      @presented_item = present_example(schema_item)
      @choose_sign_in = schema_item["details"]["choose_sign_in"]
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

    test "presents the title" do
      assert_equal @choose_sign_in["title"], @presented_item.title
    end

    test "presents the description" do
      assert_equal @choose_sign_in["description"], @presented_item.description
    end

    test "presents radio button options" do
      options = @presented_item.options
      options.delete(:or)

      options.each_with_index do |option, index|
        assert_equal option[:text], @choose_sign_in["options"][index]["text"]
        assert_equal option[:hint_text], @choose_sign_in["options"][index]["hint_text"]
        assert_equal option[:value], @choose_sign_in["options"][index]["text"].parameterize
      end
      assert_equal "option", @presented_item.options_id
    end

    test 'presents :or before last radio button option' do
      assert_equal @presented_item.options[2], :or
    end

    test 'presents the back_link' do
      assert_equal schema_item['links']['parent'].first['base_path'], @presented_item.back_link
    end
  end
end
