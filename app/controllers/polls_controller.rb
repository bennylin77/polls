# encoding: UTF-8
class PollsController < ApplicationController
  before_filter :checkLogin, only: [:new, :create]
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @poll }
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
