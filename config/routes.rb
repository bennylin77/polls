Polls::Application.routes.draw do
  
  
  get   "user/index"
  get   "polls/vote"
  get   "polls/fbComment"
  get   "polls/referenceDemo"   
  get   "polls/reference"         
  get   "polls/refAccept" 
  get   "polls/refClick" 
  get   "polls/refDelete" 
 
  
  post  "polls/refPost" 
  
  post  "polls/vote"
  
  root :to => 'polls#index'
  
  resources :polls
  resource :facebook, :except => :create do
    get :callback, :to => :create
  end
end
