module OrganisationBranding
  def organisation_logo(organisation = default_organisation)
    logo = organisation["details"]["logo"]

    logo_component_params = {
      organisation: {
        name: logo["formatted_title"],
        url: organisation["base_path"],
        brand: organisation_brand(organisation),
        crest: logo["crest"],
      }
    }

    if logo["image"]
      logo_component_params[:organisation][:image] = {
        url: logo["image"]["url"],
        alt_text: logo["image"]["alt_text"],
      }
    end

    logo_component_params
  end

  def organisation_brand_class(organisation = default_organisation)
    "#{organisation_brand(organisation)}-brand-colour"
  end

private

  def default_organisation
    content_item["links"]["organisations"].first
  end

  # HACK: Replaces the organisation_brand for executive office organisations.
  # Remove this in the future after migrating organisations to the content store API,
  # and updating them with the correct brand in the actual store.
  def organisation_brand(organisation)
    brand = organisation["details"]["brand"]
    brand = "executive-office" if executive_order_crest?(organisation)
    brand
  end

  def executive_order_crest?(organisation)
    organisation["details"]["logo"]["crest"] == "eo"
  end
end
