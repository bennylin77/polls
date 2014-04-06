# encoding: UTF-8
class LikeOption < ActiveRecord::Base
	attr_accessible :user_id, :comment_id, :sub_comment_id
	
	belongs_to :comment
	belongs_to :sub_comment
	belongs_to :user				

end