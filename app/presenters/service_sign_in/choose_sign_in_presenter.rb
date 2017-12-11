module ServiceSignIn
  class ChooseSignInPresenter < ContentItemPresenter
    def page_type
      "choose_sign_in"
    end

    def title
      choose_sign_in["title"]
    end

  private

    def choose_sign_in
      content_item["details"]["choose_sign_in"]
    end
  end
end
