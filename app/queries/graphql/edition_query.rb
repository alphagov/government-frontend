class Graphql::EditionQuery
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
            ... on Edition {
              base_path
              description
              details {
              body
                change_history
                default_news_image {
                  alt_text
                  url
                }
                display_date
                emphasised_organisations
                first_public_at
                image {
                  alt_text
                  url
                }
                political
              }
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
