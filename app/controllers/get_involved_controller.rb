class GetInvolvedController < ContentItemsController
  attr_accessor :content_item

  def show
    load_content_item
    load_get_involved_data
    @do_not_show_breadcrumbs = true
    render template: "content_items/get_involved"
  end

  def load_content_item
    content_item = get_involved_item

    @content_item = PresenterBuilder.new(
      content_item,
      content_item_path,
      view_context,
    ).presenter
  end

  def load_get_involved_data
    @open_consultation_count = retrieve_open_consultation_count
    @closed_consultation_count = retrieve_date_filtered_closed_consultations(12)
    @next_closing_consultation = retrieve_next_closing
    @recently_opened_consultations = retrieve_new_consultations
    @recent_consultation_outcomes = retrieve_consultation_outcomes
    @take_part_pages = get_involved_item["links"]["take_part_pages"]
  end

  def get_involved_item
    @get_involved_item ||= Services.content_store.content_item("/government/get-involved")
  end

  def retrieve_open_consultation_count
    Services.search_api.search({ filter_content_store_document_type: "open_consultation", count: 0 })["total"]
  end

  # Aims to find a count of consultations closed in the last n months.
  def retrieve_date_filtered_closed_consultations(months)
    cutoff_date = Time.zone.now.prev_month(months)

    query = {
      filter_content_store_document_type: "closed_consultation",
      filter_end_date: "from: #{cutoff_date}",
      count: 0,
    }

    Services.search_api.search(query)["total"]
  end

  def retrieve_next_closing
    # Ensure that on query we're not looking in the past
    cutoff_date = Time.zone.now.to_date

    query = {
      filter_content_store_document_type: "open_consultation",
      filter_end_date: "from: #{cutoff_date}",
      fields: "end_date,title,link",
      order: "end_date",
      count: 1,
    }

    Services.search_api.search(query)["results"].first
  end

  def retrieve_new_consultations
    query = {
      filter_content_store_document_type: "open_consultation",
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
      filter_content_store_document_type: "consultation_outcome",
      filter_end_date: "to: #{cutoff_date}",
      fields: "end_date,title,link,organisations",
      order: "-end_date",
      count: 3,
    }

    Services.search_api.search(query)["results"]
  end
end
