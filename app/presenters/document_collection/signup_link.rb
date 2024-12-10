module DocumentCollection
  module SignupLink
    def show_email_signup_link?
      taxonomy_topic_email_override_base_path.present? && I18n.locale == :en
    end

    def taxonomy_topic_email_override_base_path
      content_item.dig("links", "taxonomy_topic_email_override", 0, "base_path")
    end
  end
end
