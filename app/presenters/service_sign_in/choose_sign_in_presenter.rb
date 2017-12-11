module ServiceSignIn
  class ChooseSignInPresenter < ContentItemPresenter
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
      symbolized_options.map do |option|
        {
          text: option[:text],
          value: option[:text].parameterize,
          hint_text: option[:hint_text],
          bold: true
        }
      end
    end

    def back_link
      content_item['links']['parent'].first['base_path']
    end

  private

    def choose_sign_in
      content_item["details"]["choose_sign_in"]
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
