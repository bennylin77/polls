class User < ActiveRecord::Base
  attr_accessible :email, :icon
  has_one  :facebook
  has_many :references
  has_many :reference_clicks
  has_many :reference_accepts  
  has_many :polls
  has_many :user_options
  has_many :poll_options  
  has_attached_file :icon,
                    :styles => {:thumb => '60x60>', :original => '100x100>' }  
  validates_attachment :icon, :content_type=>{:content_type =>['image/jpeg', 'image/png', 'image/gif']}, 
                              :size=>{ :less_than => 10.megabytes  }    
  def icon_from_url(url)
    self.icon= URI.parse(url)
  end  
end
