module ServiceSignIn
  module Paths
    def path
      content_item["base_path"] + "/" + content_item["details"][page_type]["slug"]
    end

    def has_valid_path?
      path == @requested_content_item_path
    end

    def requesting_a_service_sign_in_page?
      true
    end
  end
end
