# encoding: UTF-8
class PollOptionHistory < ActiveRecord::Base
  attr_accessible :count, :poll_option_id
  attr_accessor  :chart
  belongs_to :poll_option

end
