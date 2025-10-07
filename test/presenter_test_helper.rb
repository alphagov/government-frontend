require "test_helper"

class PresenterTestCase < ActiveSupport::TestCase
  def create_presenter(presenter_class,
                       content_item: schema_item("worldwide_organisation"),
                       requested_path: "/test-content-item",
                       view_context: ApplicationController.new.view_context)
    presenter_class.new(content_item, requested_path, view_context)
  end

  def schema_name
    raise NotImplementedError, "Override this method in your test class"
  end

  def presented_item(type = schema_name, overrides = {})
    example = schema_item(type)
    present_example(example.merge(overrides))
  end

  def present_example(example)
    create_presenter(
      "#{schema_name.classify}Presenter".safe_constantize,
      content_item: example,
    )
  end

  def schema_item(type = schema_name, schema = schema_name)
    govuk_content_schema_example(schema, type)
  end
end
