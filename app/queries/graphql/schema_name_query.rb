class Graphql::SchemaNameQuery
  def initialize(base_path)
    @base_path = base_path
  end

  def query
    <<-QUERY
        {
          edition(
            base_path: "#{@base_path}",
            content_store: "live",
          ) {
            ... on NewsArticle {
              schema_name
            }
          }
        }
    QUERY
  end
end
