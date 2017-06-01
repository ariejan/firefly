Rails.application.routes.draw do
  get 'dashboard/show'

  get 'dashboard', to: 'dashboard#show'
  root to: redirect('/dashboard')
end
