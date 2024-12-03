class Graphql::NewsArticleQuery
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
              base_path
              description
              details
              document_type
              first_published_at
              links {
                available_translations {
                  base_path
                  locale
                }
                government {
                  details {
                    current
                  }
                  title
                }
                organisations {
                  base_path
                  content_id
                  title
                }
                people {
                  base_path
                  content_id
                  title
                }
                taxons {
                  base_path
                  content_id
                  document_type
                  phase
                  title
                  links {
                    parent_taxons {
                      base_path
                      content_id
                      document_type
                      phase
                      title
                    }
                  }
                }
                topical_events {
                  base_path
                  content_id
                  title
                }
                world_locations {
                  base_path
                  content_id
                  title
                }
              }
              locale
              schema_name
              title
            }
          }
        }
    QUERY
  end
end
