Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'

  namespace :steps do
    namespace :check do
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
