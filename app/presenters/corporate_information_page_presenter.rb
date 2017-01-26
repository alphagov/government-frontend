class CorporateInformationPagePresenter < ContentItemPresenter
  include ContentsList
  include OrganisationBranding

  def body
    content_item["details"]["body"]
  end
end
