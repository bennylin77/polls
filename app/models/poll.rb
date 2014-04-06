# encoding: UTF-8
class Poll < ActiveRecord::Base
  attr_accessible :title, :description, :kind
  attr_accessor  :chart, :chart1, :chart2
  has_many :poll_options, dependent: :destroy 
  has_many :references, dependent: :destroy  
  belongs_to :user
  
  validates :title, :presence =>{:message => "請填寫投票主題"}
end
