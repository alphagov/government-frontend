class SpecialistDocumentFacet
  attr_reader :content_base_path,
              :type,
              :main_facet_key,
              :main_facet_name,
              :allowed_values,
              :sub_facet_key,
              :sub_facet_name,
              :sub_facet_allowed_values

  def initialize(content_base_path, facet_schema)
    @content_base_path = content_base_path
    @type = facet_schema["type"]
    @main_facet_key = facet_schema["key"]
    @main_facet_name = facet_schema["name"]
    @sub_facet_key = facet_schema["sub_facet_key"]
    @sub_facet_name = facet_schema["sub_facet_name"]
    @allowed_values = facet_schema["allowed_values"]

    if @allowed_values
      @sub_facet_allowed_values = @allowed_values.map { |main_facet|
        main_facet["sub_facets"]&.map do |sub_facet|
          {
            "label" => [main_facet["label"], sub_facet["label"]].join(" - "),
            "value" => sub_facet["value"],
          }
        end
      }.compact.flatten
    end
  end

  def main_facet_label_and_values_from(content_item_metadata)
    [content_item_metadata[main_facet_key]].compact.flatten.map do |value|
      dig_label_and_value_from(value, allowed_values, main_facet_name)
    end
  end

  def sub_facet_label_and_values_from(content_item_metadata)
    [content_item_metadata[sub_facet_key]].compact.flatten.map do |value|
      dig_label_and_value_from(value, sub_facet_allowed_values, sub_facet_name)
    end
  end

private

  def dig_label_and_value_from(value, allowed_values_list, facet_name)
    label_value_hash = allowed_values_list&.detect { |allowed_value| allowed_value["value"] == value }
    return label_value_hash.select { |k, _| %w[label value].include?(k) } if label_value_hash

    notify_error_value_not_found(facet_name, value)
    { value: value }
  end

  def notify_error_value_not_found(facet_name, value)
    GovukError.notify(
      "Facet value not in list of allowed values",
      extra: { error_message: "Facet value '#{value}' not an allowed value for facet '#{facet_name}' on #{content_base_path} content item" },
    )
  end
end
