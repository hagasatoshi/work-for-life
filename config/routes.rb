Rails.application.routes.draw do
  root to: 'home#show'
  get  '*unmatched_route', to: 'application#redirect_404', format: false
end
