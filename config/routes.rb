Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :students
  devise_for :trainers
  ### API definition
  namespace :api, defaults: { format: :json } do

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
    get "/game_instances/leaderboard", to: "game_instances#get_leaderboard" #all
    get "/game_instances/active", to: "game_instances#get_active" #students
    get "/game_instances/summary", to: "game_instances#get_stats_summary"
    get "/game_instances/stats", to: "game_instances#get_stats_game" #students
    get "/game_instances/player", to: "game_instances#get_stats_player"
    resources :game_instances, :only => [:index, :show, :create, :destroy, :update]

    resources :game_enrollments, :only => [:show, :create, :destroy, :index]


  end


end
