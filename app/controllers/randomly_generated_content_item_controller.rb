class RandomlyGeneratedContentItemController < ContentItemsController
private

  def load_content_item
    random_example = GovukSchemas::RandomExample.for_schema(
      frontend_schema: params[:schema].underscore,
    )

    # Use provided schema_name rather than a randomly generated one
    random_example["schema_name"] = params[:schema].underscore
    @content_item = present(random_example)
  end

  def set_expiry; end
end
