get '/', to: 'dashboard#index', as: :dashboard

get '/items/:id.png', to: 'items#qrcode', as: :item_qrcode
resources :items
