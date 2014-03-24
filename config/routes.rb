Polls::Application.routes.draw do
  
  
  get   "user/index"

  root :to => 'polls#index'
  
  resources :polls
  resource :facebook, :except => :create do
    get :callback, :to => :create
  end
end
