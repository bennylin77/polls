class Reference < ActiveRecord::Base
  attr_accessible :link, :kind
  belongs_to  :user
  belongs_to  :poll
  belongs_to  :poll_option
  belongs_to  :article      
  has_many  :reference_clicks, dependent: :destroy
  has_many  :reference_accepts, dependent: :destroy  
end
