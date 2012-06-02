Firefly::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'expand', to: 'urls#expand'
    end
  end
end
