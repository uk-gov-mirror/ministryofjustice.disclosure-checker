Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'

  namespace :steps do
    namespace :check do
    end
  end
end
