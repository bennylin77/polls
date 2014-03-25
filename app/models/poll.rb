# encoding: UTF-8
class Poll < ActiveRecord::Base
  attr_accessible :title, :description, :kind
  attr_accessor  :chart
  has_many :poll_options
  belongs_to :user
  
  validates :title, :presence =>{:message => "請填寫投票主題"}
end
