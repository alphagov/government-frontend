module RummagerFields
  TAXON_SEARCH_FIELDS = %w(content_store_document_type
                           description
                           image_url
                           link
                           organisations
                           public_timestamp
                           title).freeze

  FEED_SEARCH_FIELDS = %w(title
                          link
                          description
                          display_type
                          public_timestamp).freeze
end
