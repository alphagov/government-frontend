class GetInvolvedController < ApplicationController
  attr_accessor :content_item

  def show
    load_content_item
    load_get_involved_data
    @do_not_show_breadcrumbs = true
    render template: "content_items/get_involved"
  end

  def load_content_item
    content_item = Services.content_store.content_item("/government/get-involved")

    if Services.feature_toggler.use_recommended_related_links?(content_item["links"], request.headers)
      content_item["links"]["ordered_related_items"] = content_item["links"].fetch("suggested_ordered_related_items", [])
    end

    @content_item = PresenterBuilder.new(
      content_item,
      content_item_path,
      view_context,
    ).presenter
  end

  def load_get_involved_data
    @open_consultation_count = retrieve_given_document_type("open_consultation")["total"]
    @closed_consultation_count = retrieve_date_filtered_closed_consultations(12)
    @next_closing_consultations = [retrieve_next_closing]
    @recently_opened_consultations = retrieve_new_consultations
    @recent_consultation_outcomes = retrieve_consultation_outcomes
    @take_part_pages = sort_take_part(retrieve_given_document_type("take_part")["results"])
  end

  def retrieve_given_document_type(document_type)
    Services.publishing_api.get_content_items(document_type: document_type).to_hash
  end

  def retrieve_special(params)
    Services.publishing_api.get_content_items(params).to_hash
  end

  # Aims to find a count of consultations closed in the last n months.
  # Could feasibly be done via Search API calls but there is no direct or indirect way to search by closing date
  # there so we have to go around the houses a bit via a single large Publishing API call.
  def retrieve_date_filtered_closed_consultations(months)
    closed_count = 0

    # Has to be a better way of doing this, will fail to count more than 500 results
    cl_docs = retrieve_special({ document_type: "closed_consultation", per_page: 500, fields: %w[details] })["results"]
    cl_docs.sort_by! { |k| -k["details"]["closing_date"] }.reverse!

    cl_docs.each do |doc|
      if Time.zone.parse(doc["details"]["closing_date"]) > Time.zone.now.prev_month(months)
        closed_count += 1
      else
        break
      end
    end

    closed_count # hard return for clarity
  end

  def retrieve_next_closing
    open_consults = retrieve_given_document_type("open_consultation")["results"]
    open_consults.sort_by! { |k| k["details"]["closing_date"] }[0]
  end

  def retrieve_new_consultations
    open_consults = retrieve_given_document_type("open_consultation")["results"]
    sorted_desc = open_consults.sort_by! { |k| k["details"]["opening_date"] }.reverse!.values_at(0..2)
    parse_organisation_acronyms(sorted_desc)
  end

  def retrieve_consultation_outcomes
    closed_consults = retrieve_given_document_type("consultation_outcome")["results"]
    sorted_desc = closed_consults.sort_by! { |k| k["details"]["closing_date"] }.reverse!.values_at(0..2)
    parse_organisation_acronyms(sorted_desc)
  end

  def parse_organisation_acronyms(consultations)
    consultations.each do |consultation|
      org_acronyms = []
      organisations = consultation["links"]["organisations"]
      organisations.each do |org_id|
        org_acronyms << Services.publishing_api.get_live_content(org_id).parsed_content["details"]["acronym"]
      end
      consultation["links"]["organisation_acronyms"] = org_acronyms
    end
  end

  def sort_take_part(take_part_pages)
    take_part_pages.sort_by { |page| page["details"]["ordering"] }
  end
end
