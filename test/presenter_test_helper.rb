require 'test_helper'

class PresenterTestCase < ActiveSupport::TestCase
  def format_name
    raise NotImplementedError, "Override this method in your test class"
  end

  def contents_link_attributes
    'data-track-category="contentsClicked" data-track-action="leftColumnH2"'
  end

private

  def presented_item(type = format_name, overrides = {})
    schema_example_content_item = schema_item(type)
    "#{format_name.classify}Presenter".safe_constantize.new(schema_example_content_item.merge(overrides))
  end

  def schema_item(type = format_name)
    govuk_content_schema_example(format_name, type)
  end
end
