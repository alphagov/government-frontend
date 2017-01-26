class CorporateInformationPagePresenter < ContentItemPresenter
  include ContentsList
  include OrganisationBranding

  def body
    content_item["details"]["body"]
  end

  def default_organisation
    organisation_content_id = content_item["details"]["organisation"]
    organisation = content_item["links"]["organisations"].detect do |org|
      org["content_id"] == organisation_content_id
    end

    raise "No organisation in links that matches the one specified in details: #{organisation_content_id}" unless organisation

    organisation
  end
end
