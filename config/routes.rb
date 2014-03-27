Polls::Application.routes.draw do
  
  
  get   "user/index"
  get   "polls/vote"
  get   "polls/fbComment"  
  post  "polls/vote"
  
  root :to => 'polls#index'
  
  resources :polls
  resource :facebook, :except => :create do
    get :callback, :to => :create
  end
end
