Rails.application.routes.draw do
  root to: 'home#show'
  get 'auth/:provider/callback', to: 'sessions#callback'
  get  '*unmatched_route', to: 'application#redirect_404', format: false
end
