class WheneverDo < ActiveRecord::Base


  def self.per10
    PollOption.all.each do |p|
        @history = PollOptionHistory.new(:count=>p.user_options.count,:poll_option_id=>p.id)
        @history.save!  
    end  
  end
   
end