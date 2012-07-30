Membit::Application.routes.draw do


  match "review" => "review#review"
  match "dashboard" => "dashboard#index"
  match "dashboard/words" => "dashboard#words"
  match "help" => "help#index"

  # Account management
  match "log_in" => "sessions#new", :as => "log_in", :via => :get
  match "log_in" => "sessions#create", :as => "log_in", :via => :post
  match "log_out" => "sessions#destroy", :as => "log_out"
  get "register" => "account#new", :as => "sign_up"
  get "account/withdraw" => "account#withdraw"
  delete "account/withdraw" => "account#destroy"
  match "account/change_password" => "account#change_password"
  match "account/create" => "account#create"

  #resources :account
  #resources :sessions

  # Teacher stuff
  match "teacher/dashboard" => "teacher/dashboard#index"
  match "teacher/dashboard/words" => "teacher/dashboard#words"
  match "teacher/dashboard/usage" => "teacher/dashboard#usage"

  # Administration
  match "registration_codes" => "registration_codes#mark", :via => :put
  resources :registration_codes

  match "admin/logs" => "admin/logs#index"
  match "admin/users" => "admin/users#index"

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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
