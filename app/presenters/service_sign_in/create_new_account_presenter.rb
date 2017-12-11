module ServiceSignIn
  class CreateNewAccountPresenter < ContentItemPresenter
    def page_type
      "create_new_account"
    end

    def title
      create_new_account["title"]
    end

  private

    def create_new_account
      content_item["details"]["create_new_account"]
    end
  end
end
