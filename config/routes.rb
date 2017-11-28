Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'warehouses#index'
  get '/warehouses' => 'warehouses#index'
  get '/warehouses/document' => 'warehouses#document'
  get '/users/new' => 'users#new'
  get '/users/index' => 'users#index'
  post '/users' => 'users#create'
  post '/delete_account' => 'users#destroy'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/api/inventory' => 'apis#get_inventory'
  get '/api/inventory/:sku' => 'apis#get_sku_inventory'
  post '/api/inventory' => 'apis#add_inventory'
  post '/api/orders' => 'apis#place_order'
  get 'api/js/inventory' => 'apis#js_inventory'

end
