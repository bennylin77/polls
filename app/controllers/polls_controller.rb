# encoding: UTF-8
class PollsController < ApplicationController
  before_filter :checkLogin, only: [:new, :create, :vote]
  
  def index
    @polls = Poll.paginate(:per_page => 5, :page => params[:page]).order('created_at DESC')
    @polls.each do |p|
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', 'Year' )
      data_table.new_column('number', 'Sales')
      
      options=Array.new
      p.poll_options.each do |o|
        options << [o.title, 500]
      end      
      data_table.add_rows(options)
      option = { width: 800, height: 300, title: p.title,  isStacked: true}
      p.chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)

    end
    
    
  end

  def show
    @poll = Poll.find(params[:id])

  end
  
  def vote
    @poll = Poll.find(params[:id])
    if request.post?
      
      user_option=nil
      @poll.poll_options.each do |o|
        if !UserOption.where(user_id: session[:user_id], poll_option_id: o.id).first.blank?
          user_option=UserOption.where(user_id: session[:user_id], poll_option_id: o.id).first  
        end
      end
            
      if user_option.blank?   
        user=User.find(session[:user_id])
        user_option=UserOption.new
        user_option.poll_option=PollOption.find(params[:option])
        user_option.user=user
        user_option.src_ip=request.remote_ip
        user_option.save!
        
        flash[:notice] = {
            :title   => "已成功投票!",
            :message => "\""+@poll.title+"\" 主題中您選擇: "+ user_option.poll_option.title         
        }       
      else
        if 3600-(Time.now-user_option.updated_at)<=0
          user_option.user_option_history=UserOptionHistory.find_or_initialize_by_user_option_id(user_option.id)
          user_option.user_option_history.poll_option=user_option.poll_option
          user_option.user_option_history.save!
          user_option.poll_option=PollOption.find(params[:option])
          user_option.src_ip=request.remote_ip   
          user_option.save!
          flash[:notice] = {
            :title   => "已成功投票!",
            :message => "\""+@poll.title+"\" 主題中您選擇: "+ user_option.poll_option.title         
          }              
        else
          flash[:notice] = {
              :title   => "目前無法投票!",
              :message => "\""+@poll.title+"\" 已投過票, "+((3600-(Time.now-user_option.updated_at))/60).to_i.to_s+"分鐘後可再重新投票"          
          }    
        end      
      end  
      redirect_to root_url
    end
  end
  
  def new
    @poll = Poll.new

  end

  def edit
    @poll = Poll.find(params[:id])
  end

  def create
    user=User.find(session[:user_id])      
    @poll  = Poll.new(title: params[:poll][:title], description: params[:poll][:description], kind: GLOBAL_VAR["general"]) 
    @poll.user = user
    params[:option].each do |key, value| 
      unless(params[:option][key].blank?)
        @poll.poll_options<<PollOption.new(title: params[:option][key])  
      end
    end    
    @poll.save!
    redirect_to root_url
    
    rescue ActiveRecord::RecordInvalid     
      if !@poll.valid?             
        render :action=>:new
      end  
  end

  def destroy
    @poll = Poll.find(params[:id])
    @poll.destroy

    respond_to do |format|
      format.html { redirect_to polls_url }
      format.json { head :no_content }
    end
  end
end
