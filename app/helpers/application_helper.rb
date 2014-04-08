# encoding: utf-8
module ApplicationHelper
  include Authentication::HelperMethods
  def host
    "http://rtes.funeasy.tw"
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
  
  def userOption(hash={})
    hash[:poll].poll_options.each do |o|
      if !UserOption.where(user_id: session[:user_id], poll_option_id: o.id).first.blank?
        @user_option=UserOption.where(user_id: session[:user_id], poll_option_id: o.id).first  
      end
    end    
    @user_option
  end
  
  def pollCount(hash={})
    @return=0
    hash[:poll].poll_options.each do |o|
      @return=o.user_options.size+@return
    end
    @return
  end  

  def pollChoice(hash={})
    @return=''
    if session[:user_id]
      hash[:poll].poll_options.each do |o|
        if !o.user_options.where(user_id: session[:user_id]).blank?
          @return=("您的選擇: "+o.title+" &#9745").html_safe
        end
      end
    end  
    @return
  end  
  
  def dayAdd(date=nil ,day=nil)
     date+day*(60 * 60 ) 
  end  
  
  def user_fb_info(user_id)
	  return User.find(user_id).facebook.profile
  end
  
  
end
