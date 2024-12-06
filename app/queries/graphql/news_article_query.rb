class Graphql::NewsArticleQuery
  def initialize(base_path)
    @base_path = base_path
  end

  def query
    <<-QUERY
        {
          edition(
            basePath: "#{@base_path}",
            contentStore: "live",
          ) {
            ... on NewsArticle {
              basePath
              description
              details
              documentType
              firstPublishedAt
              links {
                availableTranslations {
                  basePath
                  locale
                }
                government {
                  details {
                    current
                  }
                  title
                }
                organisations {
                  basePath
                  contentId
                  title
                }
                people {
                  basePath
                  contentId
                  title
                }
                taxons {
                  basePath
                  contentId
                  documentType
                  phase
                  title
                  links {
                    parentTaxons {
                      basePath
                      contentId
                      documentType
                      phase
                      title
                    }
                  }
                }
                topicalEvents {
                  basePath
                  contentId
                  title
                }
                worldLocations {
                  basePath
                  contentId
                  title
                }
              }
              locale
              schemaName
              title
            }
          }
        }
    QUERY
  end
end
