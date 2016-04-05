require 'test_helper'

class PresenterTest < ActiveSupport::TestCase
  def format_name
    raise NotImplementedError, "Override this method in your test class"
  end

private

  def presented_example_content_item(type)
    content_item = example_content_item(type)
    "#{format_name.classify}Presenter".safe_constantize.new(content_item)
  end

  def example_content_item(type)
    govuk_content_schema_example(format_name, type)
  end
end
