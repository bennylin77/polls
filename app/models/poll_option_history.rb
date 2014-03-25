# encoding: UTF-8
class PollOptionHistory < ActiveRecord::Base
  attr_accessible :count
  belongs_to :poll_option

end
