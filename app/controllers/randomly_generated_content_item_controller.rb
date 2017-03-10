class RandomlyGeneratedContentItemController < ContentItemsController
private

  def load_content_item
    schema = GovukSchemas::Schema.find(frontend_schema: params[:schema].underscore)
    random_example = GovukSchemas::RandomExample.new(schema: schema).payload

    # Use provided schema_name rather than a randomly generated one
    random_example['schema_name'] = params[:schema].underscore
    @content_item = present(random_example)
  end

  def set_expiry
  end
end
