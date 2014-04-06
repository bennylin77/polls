# encoding: UTF-8
class SubComment < ActiveRecord::Base
	attr_accessible :user_id, :comment_id, :poll_option_id, :content
	
	belongs_to :comment	
	belongs_to :user			
	has_many :like_options
end