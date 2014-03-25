# encoding: UTF-8
class PollOption < ActiveRecord::Base
  attr_accessible :title
<<<<<<< HEAD
  
=======
  has_many :user_options
  has_many :user_option_histories
>>>>>>> a0a45fdd290dad68d8e60b13b74c6cbf831d630c
end
