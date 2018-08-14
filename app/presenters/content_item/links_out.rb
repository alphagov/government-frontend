module ContentItem
  module LinksOut
    def links_out_supergroups
      @links_out_supergroups ||= fetch_links_out_supergroups
    end

    def links_out_subgroups
      @links_out_subgroups ||= fetch_links_out_subgroups
    end

  private

    def fetch_links_out_supergroups
      links_out.map { |link| link["supergroup"] }.uniq
    end

    def fetch_links_out_subgroups
      subgroups = []
      links_out.each do |link|
        if link["type"] == "content_purpose_subgroup"
          subgroups << link["title"]
        end
      end
      subgroups.uniq
    end

    def links_out
      @links_out ||= fetch_links_out
    end

    def fetch_links_out
      document_type_link_rule = DocumentTypeLinkRule.new(content_item)
      return document_type_link_rule.links if document_type_link_rule.any?
      subgroup_link_rule = SubgroupLinkRule.new(content_item)
      return subgroup_link_rule.links if subgroup_link_rule.any?
      SupergroupLinkRule.new(content_item).links
    end

    class LinkRule
      def initialize(content_item)
        @content_item = content_item
        @rules = load_rules
        @links = fetch_links
      end

      def any?
        !@links.nil?
      end

      def links
        @links || []
      end

    private

      def fetch_links
        if @content_item.dig(rule_level) &&
            @rules[rule_level] &&
            @rules[rule_level].dig(@content_item[rule_level])
          @rules[rule_level][@content_item[rule_level]]
        end
      end

      def load_rules
        Rails.configuration.taxonomy_navigation_links_out
      end

      def rule_level
        NotImplementedError
      end
    end

    class DocumentTypeLinkRule < LinkRule
      def initialize(content_item)
        super
      end

    private

      def rule_level
        'document_type'
      end
    end

    class SubgroupLinkRule < LinkRule
      def initialize(content_item)
        super
      end

    private

      def rule_level
        'content_purpose_subgroup'
      end
    end

    class SupergroupLinkRule < LinkRule
      def initialize(content_item)
        super
      end

    private

      def rule_level
        'content_purpose_supergroup'
      end
    end
  end
end
