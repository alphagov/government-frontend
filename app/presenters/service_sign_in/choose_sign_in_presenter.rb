module ServiceSignIn
  class ChooseSignInPresenter < ContentItemPresenter
    include ServiceSignIn::Paths

    # Signin pages aren't indexed and won't benefit from a schema
    def structured_data
      {}
    end

    def page_type
      "choose_sign_in"
    end

    def title
      choose_sign_in["title"]
    end

    def description
      choose_sign_in["description"]
    end

    def options
      radio_options = mapped_options.map do |option|
        {
          text: option[:text],
          value: option[:value],
          hint_text: option[:hint_text],
          bold: true
        }
      end
      # TODO: Move to decision of when or should be applied to schema
      if radio_options.length > 2
        radio_options.insert(-2, :or)
      else
        radio_options
      end
    end

    def options_id
      "option"
    end

    def back_link
      content_item['links']['parent'].first['base_path']
    end

    def selected_option(selected_value)
      mapped_options.each do |option|
        return option if option[:value] == selected_value
      end
      nil
    end

  private

    def choose_sign_in
      content_item["details"]["choose_sign_in"]
    end

    def mapped_options
      symbolized_options.map do |option|
        {
          text: option[:text],
          value: option[:text].parameterize,
          hint_text: option[:hint_text],
          url: option[:url],
        }
      end
    end

    def symbolized_options
      options_with_text.map(&:symbolize_keys)
    end

    def options_with_text
      # Sometimes the dummy store can produce options without text, may be a bug since
      # the content schemas [specify these as required](https://github.com/alphagov/govuk-content-schemas/blob/master/formats/service_sign_in.jsonnet#L39-L45)
      choose_sign_in["options"].select { |option| option['text'].present? }
    end
  end
end
