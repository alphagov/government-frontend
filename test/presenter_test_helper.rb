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
    example = schema_item(type)
    present_example(example.merge(overrides))
  end

  def present_example(example)
    "#{format_name.classify}Presenter".safe_constantize.new(example)
  end

  def schema_item(type = format_name)
    govuk_content_schema_example(format_name, type)
  end
end
