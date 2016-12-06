class SpecialistDocumentPresenter < ContentItemPresenter
  include Updatable
  include Linkable
  include ContentsList
  include TitleAndContext
  include Metadata

  def body
    content_item["details"]["body"]
  end

  def title_and_context
    super.tap do |t|
      t.delete(:context)
    end
  end
end
