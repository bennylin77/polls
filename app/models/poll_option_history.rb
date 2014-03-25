# encoding: UTF-8
class PollOptionHistory < ActiveRecord::Base
  attr_accessible :count, :poll_option_id
  belongs_to :poll_option

end
