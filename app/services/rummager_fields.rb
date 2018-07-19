module RummagerFields
  TAXON_SEARCH_FIELDS = %w(title
                           link
                           description
                           content_store_document_type
                           public_timestamp
                           organisations).freeze

  FEED_SEARCH_FIELDS = %w(title
                          link
                          description
                          display_type
                          public_timestamp).freeze
end
