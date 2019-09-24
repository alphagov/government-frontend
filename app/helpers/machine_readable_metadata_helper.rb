module MachineReadableMetadataHelper
  def machine_readable_metadata(args)
    locals = { content_item: @content_item.content_item }.merge(args)
    render("govuk_publishing_components/components/machine_readable_metadata", locals)
  end
end
