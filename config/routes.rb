IronOctopus::Application.routes.draw do

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
  root :to => "welcome#index"
  get "post_signup" => "welcome#post_signup"
  match "login" => "sessions#new"
  match "site" => "site#index"
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  resources :sessions
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "confirm" => "sessions#confirm", :as => "confirm"
  get "accept" => "invitations#accept", :as => "accept"

  get "/users/:user_id/routines/:routine_id/sheet" => "routines#sheet", :as => "routine_sheet"
  get "/users/:user_id/routines/:routine_id/perform" => "routines#perform", :as => "perform_routine"

  # Sample of named route:
  get "/trainers/:user_id/clients" => "users#clients", :as => :clients
  get "/trainers/:user_id/routines" => "routines#by_trainer", :as => :routines_by_trainer
  get "/tour/show" => "tour#show"

#  match "/trainers/:user_id/invitations" => "users#invitations", :as => :invitations

  # This route can be invoked with purchase_url(:id => product.id)
  #  match '/users/:user_id/routines/:role' => 'routines#index', :as => :routines

  resources :activities
  resources :implements
  resources :body_parts
  resources :devices

#  match "trainers/:trainer_id/routines/:routine_key" => "routines#index"
# (.:format)  optional
# match => "/:year(/:month(/:day))" => info#about, :constraints => { :year => /\d{4}/ }

  resources :users do
    resources :work
    resources :feedback
    resources :routines
    resources :licenses
    resources :invitations
  end
end
