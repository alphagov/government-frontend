module ServiceSignIn
  class CreateNewAccountPresenter < ContentItemPresenter
    include ServiceSignIn::Paths

    def page_type
      "create_new_account"
    end

    def title
      create_new_account["title"]
    end

    def body
      create_new_account["body"]
    end

    def back_link
      "#{content_item['base_path']}/#{parent_slug}"
    end

  private

    def parent_slug
      content_item["details"]["choose_sign_in"]["slug"]
    end

    def create_new_account
      content_item["details"]["create_new_account"]
    end
  end
end
