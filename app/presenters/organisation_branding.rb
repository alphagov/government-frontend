module OrganisationBranding
  def organisation_logo(organisation = first_organisation)
    {
      organisation: {
        name: organisation["details"]["logo"]["formatted_title"],
        url: organisation["base_path"],
        brand: organisation_brand(organisation),
        crest: organisation["details"]["logo"]["crest"]
      }
    }
  end

  def organisation_brand_class(organisation = first_organisation)
    "#{organisation_brand(organisation)}-brand-colour"
  end

private

  def first_organisation
    content_item["links"]["organisations"].first
  end

  # HACK: Replaces the organisation_brand for executive office organisations.
  # Remove this in the future after migrating organisations to the content store API,
  # and updating them with the correct brand in the actual store.
  def organisation_brand(organisation)
    brand = organisation["details"]["brand"]
    brand = "executive-office" if organisation["details"]["logo"]["crest"] == "eo"
    brand
  end
end
