# encoding: UTF-8
class UserOption < ActiveRecord::Base
  attr_accessible :src_ip
  
  belongs_to :user
  belongs_to :poll_option
  has_one :user_option_history
end
