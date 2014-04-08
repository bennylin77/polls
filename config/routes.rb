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
  post  "polls/createcomment"
  get   "polls/createcomment"
  get   "polls/get_user_info"
  get 	"polls/like_control"
  get   "polls/edit_comment"
  get   "polls/get_comment_data"
  root :to => 'polls#index'
  
  resources :polls
  resource :facebook, :except => :create do
    get :callback, :to => :create
  end
end
