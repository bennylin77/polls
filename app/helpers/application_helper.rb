# encoding: utf-8
module ApplicationHelper
  include Authentication::HelperMethods
  def host
    'http://rtes.funeasy.tw'
  end  
  def userOptionBlank(hash={})
    @poll = Poll.find(hash[:id])
    user_option=nil
      @poll.poll_options.each do |o|
        if !UserOption.where(user_id: session[:user_id], poll_option_id: o.id).first.blank?
          user_option=UserOption.where(user_id: session[:user_id], poll_option_id: o.id).first  
        end
      end
      if user_option.blank?
        return 1
      else
        if 3600-(Time.now-user_option.updated_at)<=0
          return 2
          else
            return 3
          end
      end
  end
  
  def pollCount(hash={})
    @return=0
    hash[:poll].poll_options.each do |o|
      @return=o.user_options.size+@return
    end
    @return
  end  
  
  
end
