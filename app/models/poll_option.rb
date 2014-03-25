# encoding: UTF-8
class PollOption < ActiveRecord::Base
  attr_accessible :title

  has_many :user_options
  has_many :user_option_histories

end
