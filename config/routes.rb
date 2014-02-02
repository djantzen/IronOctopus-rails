IronOctopus::Application.routes.draw do

  get "appointments/create"

  get "appointments/destroy"

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
  # See how all your routes lay out with "rake routes"

  resources :activities
  resources :activity_attributes
  resources :implements
  resources :body_parts
  resources :devices
  resources :sessions
  resources :locations
  resources :password_reset_requests

#  match "trainers/:trainer_id/routines/:routine_key" => "routines#index"
# (.:format)  optional
# match => "/:year(/:month(/:day))" => info#about, :constraints => { :year => /\d{4}/ }
 # get "/profiles/:user_id/new" => "profiles#new"
#  get "/profiles/:user_id/new" => "profiles#new"

  resources :users do
    resources :work
    resources :feedback
    resources :routines
    resources :programs
    resources :licenses
    resources :invitations
    resource :day_planner
    resource :profile
    resources :appointments
  end

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  root :to => "welcome#index"
  get "post_signup" => "welcome#post_signup"
  get "login" => "sessions#new"

  get "/users/is_login_unique/:login" => "users#is_login_unique", :as => "is_login_unique"
  get "/users/:user_id/routines/is_name_unique/:routine_id" => "routines#is_name_unique", :as => "is_routine_name_unique"
  get "/users/:user_id/programs/is_name_unique/:program_id" => "programs#is_name_unique", :as => "is_program_name_unique"
  get "/activities/is_name_unique/:activity_id" => "activities#is_name_unique", :as => "is_activity_name_unique"
  get "/implements/is_name_unique/:implement_id" => "implements#is_name_unique", :as => "is_implement_name_unique"
  get "/cities/search/:name" => "cities#search", :as => "search_cities"

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "confirm" => "sessions#confirm", :as => "confirm"
  get "accept" => "invitations#accept", :as => "accept"
  get "feedback" => "feedback#index", :as => "feedback"

  get "/users/:user_id/routines/:routine_id/sheet" => "routines#sheet", :as => "routine_sheet"
  get "/users/:user_id/routines/:routine_id/perform" => "routines#perform", :as => "perform_routine"
  get "/users/:user_id/settings" => "users#settings", :as => "user_settings"
  #get "/users/:user_id/routines/:routine_id/activity_sets" => "routines#fetch_routine", :as => :fetch_routine
  get "/users/:user_id/routines" => "routines#by_client", :as => :routines_by_client
  get "/users/:user_id/scores_by_day" => "users#scores_by_day"
  get "/users/:user_id/client_score_differentials" => "users#client_score_differentials"
  get "/users/:user_id/activity_type_breakdown" => "users#activity_type_breakdown"
  get "/users/:user_id/body_part_breakdown" => "users#body_part_breakdown"
  get "/users/:user_id/activity_performance_over_time" => "users#activity_performance_over_time"

  get "/trainers/:user_id/clients" => "users#clients", :as => :clients
  get "/trainers/:user_id/routines" => "routines#by_trainer", :as => :routines_by_trainer
  get "/trainers/:user_id/programs" => "programs#by_trainer", :as => :programs_by_trainer
  get "/tour/show" => "tour#show", :as => :tour

  get "/admin/proxied_pages" => "admin/proxied_pages#get", :as => :proxied_pages

  #  match "/trainers/:user_id/invitations" => "users#invitations", :as => :invitations

  # This route can be invoked with purchase_url(:id => product.id)
  #  match '/users/:user_id/routines/:role' => 'routines#index', :as => :routines

end
