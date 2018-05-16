class CorporateInformationPagePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::ContentsList
  include ContentItem::TitleAndContext
  include ContentItem::OrganisationBranding
  include ContentItem::CorporateInformationGroups

  def structured_data
    # TODO: implement a schema
    {}
  end

  def page_title
    page_title = super
    page_title += " - #{default_organisation['title']}" if default_organisation
    page_title
  end

  def title_and_context
    super.tap do |t|
      t.delete(:average_title_length)
      t.delete(:context)
    end
  end

  def contents_items
    super + extra_headings
  end

private

  def extra_headings
    extra_headings = []
    extra_headings << corporate_information_heading if corporate_information?
    extra_headings
  end

  def default_organisation
    organisation_content_id = content_item["details"]["organisation"]
    organisation = nil
    if organisations.present?
      organisation = organisations.detect { |org| org["content_id"] == organisation_content_id }
      raise "No organisation in links that matches the one specified in details: #{organisation_content_id}" unless organisation
    end

    organisation
  end

  def organisations
    content_item["links"]["organisations"] || []
  end
end
