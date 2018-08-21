module Supergroups
  class Transparency < Supergroup
  private

    def fetch_content
      return [] unless @taxon_ids.any?
      MostRecentContent.fetch(content_ids: @taxon_ids, current_path: @current_path, filters: @filters)
    end
  end
end
