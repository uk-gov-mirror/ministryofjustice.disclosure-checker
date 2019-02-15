# :nocov:
def edit_step(name)
  resource name,
           only: [:edit, :update],
           controller: name,
           path_names: {edit: ''}
end
# :nocov:

Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'

  get 'about/contact'
  get 'about/cookies'
  get 'about/privacy'
  get 'about/terms_and_conditions'

  namespace :steps do
    namespace :check do
      edit_step :kind
      edit_step :caution_date
    end
  end

  resource :errors, only: [] do
    get :invalid_session
    get :unhandled
    get :not_found
  end

  # catch-all route
  # :nocov:
  match '*path', to: 'errors#not_found', via: :all, constraints:
    lambda { |_request| !Rails.application.config.consider_all_requests_local }
  # :nocov:
end
