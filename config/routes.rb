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

  resources :transactions, only: [:edit, :update]

  get 'admin/inventories', to: 'inventories#index'
  get 'admin/transactions', to: 'transactions#index'

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
