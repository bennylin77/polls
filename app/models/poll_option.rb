# encoding: UTF-8
class PollOption < ActiveRecord::Base
  attr_accessible :title, :user_id, :poll_id
  belongs_to :poll
  belongs_to :user  
  has_many :references, dependent: :destroy    
  has_many :user_options, dependent: :destroy  
  has_many :user_option_histories, dependent: :destroy 
  has_many :poll_option_histories, dependent: :destroy 
end
