Rails.application.routes.draw do
  namespace :admin do
    resources :dummy
  end
end
