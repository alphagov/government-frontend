class WebchatController < ApplicationController
  layout false

  def show
    @webchat_config = Webchat.find(request.path)
  rescue ActiveModel::ValidationError, StandardError => e
    Rails.logger.error "Webchat error: #{e.message}"
    render plain: "Webchat configuration not found", status: :not_found
  end

  def service_sign_in_options
    return head :not_found unless content_item_path.include?("sign-in")

  end
end
