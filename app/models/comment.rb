# encoding: UTF-8
class Comment < ActiveRecord::Base
	attr_accessible :user_id, :poll_id, :poll_option_id, :content
	
	has_many :sub_comments				
	has_many :like_options
end