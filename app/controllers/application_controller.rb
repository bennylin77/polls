# encoding: utf-8
class ApplicationController < ActionController::Base
  include Authentication
  protect_from_forgery
  rescue_from FbGraph::Exception, :with => :fb_graph_exception

  def host
    'http://rtes.funeasy.tw'
  end
  
  def fb_graph_exception(e)
    flash[:error] = {
      :title   => e.class,
      :message => e.message
    }
    #current_user.try(:destroy)
    redirect_to root_url
  end  
  
  def checkLogin
    unless User.find_by_id(session[:user_id])
      flash[:notice] = {
          :title   => "請先登入, 謝謝!",
          :message => "您沒有操作的權限 "          
      }        
      redirect_to root_url
    end    
  end   
end
