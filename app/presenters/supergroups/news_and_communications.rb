module Supergroups
  class NewsAndCommunications < Supergroup
    attr_reader :content

    def initialize(current_path, taxon_ids)
      @taxon_ids = taxon_ids
      @current_path = current_path
      @content = fetch
    end

    def tagged_content
      return unless @content.any?
      {
        documents: documents,
        promoted_content: promoted_content,
      }
    end

  private

    def documents
      items = @content.drop(promoted_content_count)
      format_document_data(items)
    end

    def promoted_content
      items = @content.take(promoted_content_count)
      content = format_document_data(items, data_category: "ImageCardClicked")

      content.each do |document|
        document_image = news_item_photo(document[:link][:path])
        document[:image] = {
            url: document_image["url"],
            alt: document_image["alt_text"],
            context: document_image["context"]
        }
      end

      content
    end

    def fetch
      return [] if @taxon_ids.empty?

      MostRecentContent.fetch(
        content_ids: @taxon_ids,
        current_path: @current_path,
        filter_content_purpose_supergroup: "news_and_communications"
      )
    end

    def promoted_content_count
      3
    end

    def news_item_photo(base_path)
      default_news_image = {
        "url" => "https://assets.publishing.service.gov.uk/government/assets/placeholder.jpg",
        "alt_text" => ""
      }

      news_item = ::Services.content_store.content_item(base_path).to_h

      image = news_item["details"]["image"] || default_news_image
      date = Date.parse(news_item["public_updated_at"]).strftime("%d %B %Y")
      document_type = news_item["document_type"].humanize
      image["context"] = "#{document_type} - #{date}"

      image
    end
  end
end
