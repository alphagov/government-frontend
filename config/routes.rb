Rails.application.routes.draw do
  unless Rails.env.production?
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
    get 'random/:schema' => 'randomly_generated_content_item#show'
  end

  mount GovukPublishingComponents::Engine, at: "/component-guide" if defined?(GovukPublishingComponents)

  get 'healthcheck', to: proc { [200, {}, ['']] }

  get 'log-in-file-self-assessment-tax-return/choose-sign-in', to: 'self_assessment_signin#choose_sign_in', as: :choose_sign_in, defaults: { path: '/log-in-file-self-assessment-tax-return/choose-sign-in' }
  get 'log-in-file-self-assessment-tax-return/not-registered', to: 'self_assessment_signin#not_registered', defaults: { path: '/log-in-file-self-assessment-tax-return/not-registered' }
  get 'log-in-file-self-assessment-tax-return/lost-account-details', to: 'self_assessment_signin#lost_account_details', as: :lost_account_details, defaults: { path: '/log-in-file-self-assessment-tax-return/lost-account-details' }
  post 'log-in-file-self-assessment-tax-return/choose-sign-in', to: 'self_assessment_signin#sign_in_options'

  get '*path/:variant' => 'content_items#show',
      constraints: {
        variant: /print/
      }

  get '*path(.:locale)(.:format)' => 'content_items#show',
      constraints: {
        format: /atom/,
        locale: /\w{2}(-[\d\w]{2,3})?/,
      }
end
