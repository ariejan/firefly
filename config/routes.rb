Firefly::Application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'expand', to: 'urls#expand'
    end
  end

  match '/:fingerprint', to: 'urls#redirect'
end
