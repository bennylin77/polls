class UserOptionHistory < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user_option
  belongs_to :poll_option
end
