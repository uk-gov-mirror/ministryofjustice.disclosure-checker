Rails.application.routes.draw do
  root 'home#index'

  get 'home/index'

  namespace :steps do
  end
end
