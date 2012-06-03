Firefly::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'shorten',   to: 'urls#shorten'
      get  'expand',    to: 'urls#expand'
    end
  end

  match '/:fingerprint', to: 'urls#redirect', as: 'short'
end
