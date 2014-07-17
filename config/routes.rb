GoogleTest::Application.routes.draw do

  root 'signups#new' #normal code

  # root 'staticpages#maintenance' #maintenance mode
  # get '/new', to: 'signups#new' #maintenance mode

  resources :signups, only: [:new, :create]
  get '/edit', to: 'signups#edit', as: 'edit_signup'
  patch 'signups', to: 'signups#update'

  get 'requests/new', to: 'requests#new', as: 'new_request'
  post 'requests', to: 'requests#create'
  get 'requests/success', to: 'requests#success'
  # get 'requests/edit/:edit_id', to: 'requests#edit', as: 'edit_request'
  # patch 'requests/:edit_id', to: 'requests#update', as: 'request'

  resources :inventories, only: [:new, :create, :destroy]
  patch 'inventories/:id/edit', to: 'inventories#update', as: 'edit_inventory'
  patch 'inventories/:id/destroy_description', to: 'inventories#destroy_description', as: 'destroy_description'  
  get 'inventories/manage', to: 'inventories#manage', as: 'manage_inventory'
  
  resources :borrows, only: [:edit, :update]

  get 'admin/statuses', to: 'statuses#index'
  post 'admin/statuses/new', to: 'statuses#create', as: 'new_status'
  get 'admin/statuses/:id/edit', to: 'statuses#edit', as: 'edit_status'
  patch 'admin/statuses/:id/edit', to: 'statuses#update'

  get 'admin/itemlists', to: 'itemlists#index'
  post 'admin/itemlists/new', to: 'itemlists#create', as: 'new_itemlist'
  get 'admin/itemlists/:id/edit', to: 'itemlists#edit', as: 'edit_itemlist'
  patch 'admin/itemlists/:id/edit', to: 'itemlists#update'

  post 'admin/categorylists/new', to: 'categorylists#create', as: 'new_categorylist'
  get 'admin/categorylists/:id/edit', to: 'categorylists#edit', as: 'edit_categorylist'
  patch 'admin/categorylists/:id/edit', to: 'categorylists#update'

  post 'admin/statuscategory/new', to: 'statuscategories#create', as: 'new_statuscategory'
  get 'admin/statuscategory/:id/edit', to: 'statuscategories#edit', as: 'edit_statuscategory'
  patch 'admin/statuscategory/:id/edit', to: 'statuscategories#update'

  get 'admin/inventories', to: 'inventories#index'
  get 'admin/borrows', to: 'borrows#index'

  get 'termsofservice', to: 'staticpages#terms', as: 'terms'
  get 'privacypolicy', to: 'staticpages#policy', as: 'policy'

    # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
