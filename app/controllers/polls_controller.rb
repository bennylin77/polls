# encoding: UTF-8
class PollsController < ApplicationController
  before_filter :checkLogin, only: [:new, :create, :vote]
  before_filter :checkUser,  only: [:destroy]
    
  def index

    @polls = Poll.paginate(per_page: 15, page: params[:page], conditions: ["verified_c = true"]).order('created_at DESC')
    @polls.each do |p|
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', '選項' )
      data_table.new_column('number', '人')
      
      options=Array.new
      user_counts = 0
      p.poll_options.order('id ASC').each do |o| 
        options << [o.title, o.user_options.size]
        user_counts= user_counts+o.user_options.size
      end      
      data_table.add_rows(options)
      option = { width: 600, height: 240,  title: '目前得票比例 ('+user_counts.to_s+'人)'}
      p.chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)    
    end  
  
  end

  def show
    @poll = Poll.where(id: params[:id], verified_c: true).first
    if !@poll.blank?
      user_counts = 0    
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', '選項' )
      data_table.new_column('number', '人')
      
      options=Array.new
      @poll.poll_options.order('id ASC').each do |o| 
        options << [o.title, o.user_options.size]
        user_counts= user_counts+o.user_options.size
      end      
      data_table.add_rows(options)
      option = { width: 600, height: 300,  title: '目前得票比例 ('+user_counts.to_s+'人)'}
      @poll.chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)

      ### trend ###
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('datetime', 'Date' ) #first column is Datetime
      option_list = Array.new
      @poll.poll_options.order('id asc').each do |o|  
        data_table.new_column('number', o.title) #others are options' count
        option_list << o.id
      end
      option_cnt = @poll.poll_options.count      #total options

      data_table.add_rows(PollOptionHistory.count_for_chart(option_list,option_cnt))
      option = { width: 600, height: 300, title: '投票趨勢'}
      @chart2 = GoogleVisualr::Interactive::LineChart.new(data_table, option)
    else
      redirect_to root_url
    end  
    
  #  @comment = Comment.where(:poll_id => @poll.id)   # test line
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
        if !params[:option].blank?
          user=User.find(session[:user_id])
          user_option=UserOption.new
          if params[:option]!='0'
            user_option.poll_option=PollOption.find(params[:option])
            user_option.user=user
            user_option.src_ip=request.remote_ip
            user_option.save!
            flash[:notice] = {
              :title   => "已成功投票!",
              :message => "\""+@poll.title+"\" 主題中您選擇: "+ user_option.poll_option.title         
            }                
          else
            user_option.poll_option=PollOption.new(title: params[:new_option], user_id: session[:user_id], poll_id: @poll.id)
            user_option.user=user
            user_option.src_ip=request.remote_ip
            user_option.save!
            flash[:notice] = {
              :title   => "已成功投票!",
              :message => "\""+@poll.title+"\" 主題中您選擇: "+ user_option.poll_option.title         
            }                 
          end 
        else
          flash[:notice] = {
            :title   => "投票 失敗",
            :message => "您未選擇任何投票選項"          
          }            
        end               
      else
        if 3600-(Time.now-user_option.updated_at)<=0
          if !params[:option].blank?
            user_option.user_option_history=UserOptionHistory.find_or_initialize_by_user_option_id(user_option.id)
            user_option.user_option_history.poll_option=user_option.poll_option
            user_option.user_option_history.save!
            if params[:option]!='0'
              user_option.poll_option=PollOption.find(params[:option])
              user_option.src_ip=request.remote_ip   
              user_option.save!
              flash[:notice] = {
                :title   => "已成功投票!",
                :message => "\""+@poll.title+"\" 主題中您選擇: "+ user_option.poll_option.title         
              }             
            else
              user_option.poll_option=PollOption.new(title: params[:new_option], user_id: session[:user_id], poll_id: @poll.id)
              user_option.src_ip=request.remote_ip
              user_option.save!
              flash[:notice] = {
                :title   => "已成功投票!",
                :message => "\""+@poll.title+"\" 主題中您選擇: "+ user_option.poll_option.title         
              }                 
            end  
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
         if 3600*24-(Time.now-@user.polls.last.updated_at)<=0 
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
          @poll.poll_options<<PollOption.new(title: params[:option][key], user_id: session[:user_id])  
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
  
  def fbComment
    @poll_option = PollOption.find(params[:poll_option_id])    
  end
  
  def get_user_info
	@cur_user_fb_info = User.find(session[:user_id]||1).facebook.profile
	session[:username] = @cur_user_fb_info.name
	session[:user_pic] = @cur_user_fb_info.picture
	@choice = ""
	Poll.find(params[:poll_id]).poll_options.each do |p|
		unless p.user_options.where(user_id: session[:user_id]||1).blank?
			@choice = p.title
		end	
	end
	
	@comment = Comment.where(:poll_id => params[:poll_id])
	@newcomment= Comment.new
  end
  
  def createcomment
	
  	#@flag = 1
  	@cur_user_fb_info = User.find(session[:user_id]||1).facebook.profile
  	#@choice = ""
	
	Poll.find(params[:comment][:poll_id]).poll_options.each do |p|
		unless p.user_options.where(user_id: session[:user_id]||1).blank?
			@cur_option_id = p.id
		end	
	end
	
	if request.post?
		if params[:comment][:type] == "main"
			@newcomment1 = Comment.new
			@newcomment1.user_id=session[:user_id]
			@newcomment1.poll_id=params[:comment][:poll_id]
			@newcomment1.content=params[:comment][:content]
			
			@newcomment1.poll_option_id = @cur_option_id
		
			@newcomment1.save!
			
			#@comment = Comment.where(:poll_id => params[:comment][:poll_id])
			#params[:poll_id] = params[:comment][:poll_id]
		
		elsif params[:comment][:type] == "sub"  # sub_comment with method GET (request.get?)
		#	@flag = 0
			@sub_com = SubComment.new
			@sub_com.user_id=session[:user_id]
			@sub_com.comment_id=params[:comment][:comment_id]
			@sub_com.content=params[:comment][:content]
	
			@sub_com.poll_option_id = @cur_option_id			
		
			#@sub_com.content = params[:_content]
			@sub_com.save!
			@last_id=params[:comment][:comment_id]
			#@comment = Comment.where(:poll_id => @poll_id)
			#params[:poll_id] = @poll_id
		else 
		end
	end	
	@comment = Comment.where(:poll_id => params[:comment][:poll_id]).last
	params[:poll_id] = params[:comment][:poll_id]
	@newcomment = Comment.new
  end
  
  def like_control
  	@id = params[:_id]
  	@span_id = ""
  	@div_id = ""
  	@div_content = ""
  	@type = params[:_type]
  	if params[:_flag].to_i == 1
  		if @type=="main"
  			@like = LikeOption.where(:user_id=>session[:user_id], :comment_id=>params[:_id]).first
  		else
  			@like = LikeOption.where(:user_id=>session[:user_id], :sub_comment_id=>params[:_id]).first
  		end	
  		@like.destroy
  		@div_content = "讚"
  	else
		@like = LikeOption.new(:user_id=>session[:user_id])
		if @type=="main"
			@like.comment_id = params[:_id]
		else
			@like.sub_comment_id = params[:_id]
		end
		@like.save!
		@div_content = "收回讚"
	end
	
	if @type=="main"
		@button_id = "main_"+params[:_id].to_s
		@span_id = "main_sp_"+params[:_id].to_s
	else
		@button_id = "sub_"+params[:_id].to_s
		@span_id = "sub_sp_"+params[:_id].to_s
	end
	
	respond_to do |format|
		format.js {}
	end
  end
  

end
