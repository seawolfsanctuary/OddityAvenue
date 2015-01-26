OddityAvenue::Application.routes.draw do

  get "contact" => "static_pages#contact"
  post "make_contact" => "static_pages#make_contact"

  get "about" => "static_pages#about"

  resources :portfolio
    get 'portfolio/category/:category',  to: 'portfolio#index',  as: :portfolio_item_category
  resources :shop
    get 'shop/category/:category',       to: 'shop#index',       as: :shop_item_category

  devise_for :users, path: 'admin', class_name: "Admin::User", skip: [:registrations]
    as :user do
      get 'admin/users/edit' => 'devise/registrations#edit', as: 'edit_registration'
      put 'admin/users/:id' => 'devise/registrations#update', :as => 'registration'
    end

  get "admin" => "application#admin"
  namespace :admin do
    get  "content/home",    controller: :static_pages, action: :edit_home
    post "content/home",    controller: :static_pages, action: :update_home
    get  "content/about",   controller: :static_pages, action: :edit_about
    post "content/about",   controller: :static_pages, action: :update_about
    get  "content/contact", controller: :static_pages, action: :edit_contact
    post "content/contact", controller: :static_pages, action: :update_contact

    resources :portfolio
    get 'portfolio/:id/move_to_shop' => 'portfolio#move_to_shop', as: 'move_portfolio_to_shop'

    resources :shop
    post "shop/update_delivery_opts", controller: :shop, action: :update_delivery_opts
    get 'shop/:id/move_to_portfolio' => 'shop#move_to_portfolio', as: 'move_shop_to_portfolio'
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'static_pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
