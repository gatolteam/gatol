Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :students
  devise_for :trainers

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



  ### API definition
  namespace :api, defaults: { format: :json } do
    ### Add API here

    resources :trainers, :only => [:show, :create]
    get "/trainers/:auth_token/confirm", to: "trainers#verify"
    post "/trainers/reset", to: "trainers#reset"
    post "/trainers/update", to: "trainers#update"
    delete "/trainers", to: "trainers#destroy"

    resources :students, :only => [:show, :create]
    get "/students/:auth_token/confirm", to: "students#verify"
    post "/students/reset", to: "students#reset"
    post "/students/update", to: "students#update"
    delete "/students", to: "students#destroy"

    resources :sessions, :only => [:create, :destroy]

    resources :question_sets, :only => [:index, :show, :destroy]
    post "/question_sets/import", to: "question_sets#import"
    resources :question_sets do
      collection { post :import }
    end
    resources :games, :only => [:index, :show, :create, :destroy, :update]
    resources :game_templates, :only => [:index, :show, :create, :destroy, :update]
    resources :game_instances, :only => [:show, :create, :destroy, :update]
    get "/game_instances/active", to: "game_instances#get_active"
    get "/game_instances/all", to: "game_instances#get_status_all"
    get "/game_instances/stats", to: "game_instances#get_stats_game"
    get "/game_instances/player", to: "game_instances#get_stats_player"

    resources :game_enrollments, :only => [:show]


  end


end
