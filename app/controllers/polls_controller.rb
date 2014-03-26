# encoding: UTF-8
class PollsController < ApplicationController
  before_filter :checkLogin, only: [:new, :create, :vote]
  before_filter :checkUser,  only: [:destroy]
  
  def index
    @polls = Poll.paginate(per_page: 5, page: params[:page], conditions: ["verified_c = true"]).order('created_at DESC')
    @polls.each do |p|
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', '選項' )
      data_table.new_column('number', '人')
      
      options=Array.new
      p.poll_options.each do |o|
        
        options << [o.title, o.user_options.size]
      end      
      data_table.add_rows(options)
      option = { width: 600, height: 300}
      p.chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)
    end
    
    
  end

  def show
    @poll = Poll.find(params[:id])


    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', '選項' )
    data_table.new_column('number', '人')
    
    options=Array.new
    @poll.poll_options.each do |o|
      options << [o.title, o.user_options.size]
    end      
    data_table.add_rows(options)
    option = { width: 600, height: 300}
    @poll.chart1 = GoogleVisualr::Interactive::PieChart.new(data_table, option)


    ######
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Date' )
    option_list = Array.new
    @poll.poll_options.each do |o|  
      data_table.new_column('number', o.title)
      option_list << o.id
    end
    
    PollOptionHistory.find(:all,
                           :select=>'poll_option_id,count,created_at',
                           :conditions=>{:poll_option_id=>option_list},
                           :order=>'created_at asc'
                            ).each do |p|

    end  

    options=Array.new
    data_table.add_rows(options)
    option = { width: 900, height: 300}
    @poll.chart2 = GoogleVisualr::Interactive::LineChart.new(data_table, option)

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
          if !params[:option].blank?
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
                :title   => "投票 失敗",
                :message => "您未選擇任何投票選項"          
            }            
          end                  
        else
          flash[:notice] = {
              :title   => "目前無法投票!",
              :message => "\""+@poll.title+"\" 已投過票, "+((3600-(Time.now-user_option.updated_at))/60).to_i.to_s+"分鐘後可再重新投票"          
          }    
        end      
      end    
      if request.xhr?
        render :json => {success: "動作完成" }.to_json                 
      else
        redirect_to root_url
      end    
    else
      if request.xhr?
        render layout: false 
      end     
    end
  end
  
  def new
    @poll = Poll.new
    @user=User.find(session[:user_id])

    if request.xhr?
       if @user.polls.empty?
        render layout: false 
       else
         if 3600-(Time.now-@user.polls.last.updated_at)<=0 
          render layout: false
         else  
          render template: "polls/newLimit", layout: false 
         end
       end  
    else
      redirect_to root_url   
    end          
  end

  def edit
    @poll = Poll.find(params[:id])
  end

  def create
    user=User.find(session[:user_id])      
    @poll  = Poll.new(title: params[:poll][:title], description: params[:poll][:description], kind: GLOBAL_VAR["general"]) 
    @poll.user = user
    if !params[:option].blank?
      params[:option].each do |key, value| 
        unless(params[:option][key].blank?)
          @poll.poll_options<<PollOption.new(title: params[:option][key])  
        end
      end    
      @poll.save!
      redirect_to root_url
    else
      flash[:notice] = {
        :title   => "新增主題 失敗",
        :message => "您未填寫任何投票選項"          
      }       
      redirect_to root_url
    end    
    
    rescue ActiveRecord::RecordInvalid     
      if !@poll.valid?             
        render :action=>:new
      end  
  end

  def destroy
    @poll = Poll.find(params[:id])
    @poll.poll_options.clear
    @poll.destroy

    redirect_to root_url
  end
end
