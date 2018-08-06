module ContentItem
  module LinksOut
    def links_out_supergroups
      supergroups = links_out.delete_if { |entry| entry.values.first != "content_purpose_supergroup" }
      supergroups.map { |supergroup_entry| supergroup_entry.keys.first }
    end

    def links_out
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
