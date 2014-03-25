# encoding: UTF-8
class PollOption < ActiveRecord::Base
  attr_accessible :title
  belongs_to :poll
  has_many :user_options, dependent: :destroy 
  has_many :user_option_histories, dependent: :destroy 
  has_many :poll_option_histories, dependent: :destroy 
end
