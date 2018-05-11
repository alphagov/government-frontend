module SchemaOrg
  class NewsArticleSchema
    def initialize(presenter)
      @presenter = presenter
    end

    def structured_data
      base = ArticleSchema.new(presenter).structured_data
      # http://schema.org/NewsArticle
      base["@type"] = "NewsArticle"
      base
    end

  private

    attr_reader :presenter
  end
end
