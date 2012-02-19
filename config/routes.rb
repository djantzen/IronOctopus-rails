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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

#  resources :activity_sets
#  resources :measurement
  resources :activities
  
#  resources :routines do
#    resources :activity_sets
#  end
  
# When I construct a routine, I say, new routine for a user
# optionally, from a template
# Thus: routine creation, returns a routine_id
# Next, I select an activity and measurement 
# routine is assigned the activity and measurement, thus creating an activity set
# I may move the activity set within the routine
# routines/new {user_id, name, goal, creator_id}
# I list routines I have created
# routines/index?creator_id/1

resources :work
 
  
# (.:format)  optional
# match => "/:year(/:month(/:day))" => info#about, :constraints => { :year => /\d{4}/ }
  resources :users do
    resources :routines
  end
end
