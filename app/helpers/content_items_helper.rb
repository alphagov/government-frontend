module ContentItemsHelper
  def email_subscription_success_banner_heading(account_flash)
    if account_flash.include?("email-subscription-success")
      sanitize(t("email.subscribe_title"))
    elsif account_flash.include?("email-unsubscribe-success")
      sanitize(t("email.unsubscribe_title"))
    elsif account_flash.include?("email-subscription-already-subscribed")
      sanitize(t("email.already_subscribed_title"))
    end
  end

  def show_email_subscription_success_banner?(account_flash)
    account_flash.include?("email-subscription-success") || account_flash.include?("email-unsubscribe-success") || account_flash.include?("email-subscription-already-subscribed")
  end
end
