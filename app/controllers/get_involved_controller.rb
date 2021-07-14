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
    @open_consultation_count = Services.search_api.search({ filter_display_type: "Open consultation", count: 0 })["total"]
    @closed_consultation_count = retrieve_date_filtered_closed_consultations(12)
    @next_closing_consultation = retrieve_next_closing
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
    cutoff_date = Time.zone.now.prev_month(months)

    query = {
      filter_display_type: "Closed consultation",
      filter_end_date: "from: #{cutoff_date}",
      count: 0,
    }

    Services.search_api.search(query)["total"]
  end

  def retrieve_next_closing
    # Ensure that on query we're not looking in the past
    cutoff_date = Time.zone.now.to_date

    query = {
      filter_display_type: "Open consultation",
      filter_end_date: "from: #{cutoff_date}",
      fields: "end_date,title,link",
      order: "end_date",
      count: 1,
    }

    Services.search_api.search(query)["results"].first
  end

  def retrieve_new_consultations
    query = {
      filter_display_type: "Open consultation",
      fields: "end_date,title,link,organisations",
      order: "-start_date",
      count: 3,
    }

    Services.search_api.search(query)["results"]
  end

  def retrieve_consultation_outcomes
    # Ensure that on query we're not looking into the future
    cutoff_date = Time.zone.now.to_date

    query = {
      filter_display_type: "Closed consultation",
      filter_end_date: "to: #{cutoff_date}",
      fields: "end_date,title,link,organisations",
      order: "-end_date",
      count: 3,
    }

    Services.search_api.search(query)["results"]
  end

  def sort_take_part(take_part_pages)
    take_part_pages.sort_by { |page| page["details"]["ordering"] }
  end
end
