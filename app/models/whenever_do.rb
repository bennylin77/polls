class WheneverDo < ActiveRecord::Base
  def per10
  	UserOption.find( :all ,
  	 				:select=>'poll_option_id, SUM(1) as total',
  	 				:group=>'poll_option_id',
  	 				:conditions=>['created_at between ? and ?',Time.now.ago(1.hour),Time.now],
  	 			).each do |u|
  	 	@history = PollOptionHistory.new(:count=>u.total,:poll_option_id=>u.poll_option_id)
  	 	@hostory.save! 	
  	end 	

  end
  	
end