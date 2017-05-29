Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "contact", to: "static_pages#contact"
  post "make_contact", to: "static_pages#make_contact"

  get "about", to: "static_pages#about"
  get "delivery_info", to: "static_pages#delivery_info"

  resources :portfolio
    get 'portfolio/category/:category',  to: 'portfolio#index',  as: :portfolio_item_category
  resources :shop
    get 'shop/category/:category',       to: 'shop#index',       as: :shop_item_category

  devise_for :users, path: 'admin', class_name: "Admin::User", skip: [:registrations]
    as :user do
      get 'admin/users/edit', to: 'devise/registrations#edit', as: 'edit_registration'
      put 'admin/users/:id', to: 'devise/registrations#update', as: 'registration'
    end

  get "admin", to: "application#admin"
  namespace :admin do
    get  "content/home",          controller: :static_pages, action: :edit_home
    post "content/home",          controller: :static_pages, action: :update_home
    get  "content/about",         controller: :static_pages, action: :edit_about
    post "content/about",         controller: :static_pages, action: :update_about
    get  "content/delivery_info", controller: :static_pages, action: :edit_delivery_info
    post "content/delivery_info", controller: :static_pages, action: :update_delivery_info
    get  "content/contact",       controller: :static_pages, action: :edit_contact
    post "content/contact",       controller: :static_pages, action: :update_contact

    resources :portfolio
    get 'portfolio/:id/move_to_shop', to: 'portfolio#move_to_shop', as: 'move_portfolio_to_shop'

    resources :shop
    get 'shop/:id/move_to_portfolio', to: 'shop#move_to_portfolio', as: 'move_shop_to_portfolio'
  end

  root to: 'static_pages#home'
end
