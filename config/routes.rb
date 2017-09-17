Rails.application.routes.draw do

  root to: 'home#show'

  get 'auth/:provider/callback', to: 'sessions#callback'

  resources :orgs, only: %i() do
    resources :repos, only: %i() do
      resources :commits, only: %i(index)
    end
  end

  get  '*unmatched_route', to: 'application#redirect_404', format: false
end
