# encoding: utf-8
require 'will_paginate/array'
class UserController < ApplicationController
  def index
      
    @polls=Array.new
    User.find(session[:user_id]).user_options.each do |o|
      if o.poll_option.poll.verified_c
        @polls<<o.poll_option.poll
      end  
    end  
    @polls=@polls.sort{|a,b| a.id <=> b.id }.paginate(per_page: 15, page: params[:page])
  
    @polls.each do |p|
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', '選項' )
      data_table.new_column('number', '人')
      
      options=Array.new
      p.poll_options.order('id ASC').each do |o|
         options << [o.title, o.user_options.size]
      end      
      data_table.add_rows(options)
      option = { width: 600, height: 300,  title: '目前得票比例'}
      p.chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)

      ### trend ###
      data_table = GoogleVisualr::DataTable.new
      data_table.new_column('string', 'Date' )
      option_list = Array.new
      p.poll_options.order('id asc').each do |o|  
      data_table.new_column('number', o.title)
        option_list << o.id
      end
      option_cnt = p.poll_options.count
      tmp = 0
      flag= 0
      options =  Array.new
      row_list = Array.new
      PollOptionHistory.find(:all,
                           :select=>'poll_option_id,count,DATE_FORMAT(created_at,"%m/%d %H:00") as t',
                           :conditions=>{:poll_option_id=>option_list},
                           :order=>'t asc,poll_option_id asc'
                            ).each do |pp|
          if tmp != pp.t
            tmp = pp.t
            if flag==1  # skip first loop
              options << row_list   
              row_list = Array.new    
            end
            row_list << pp.t.to_s     #first col is datetime
            flag=1  
          end
          row_list << pp.count 
          tmp = pp.t
      end  
      options << row_list
      #@ssss = options
      #options1 = Array.new
      #options1 << ["03/26 01:00",4,5,6]
      #@aaa = options
      data_table.add_rows(options)
      option = { width: 600, height: 300, title: '投票趨勢'}
      p.chart2 = GoogleVisualr::Interactive::LineChart.new(data_table, option)
    end 
    render "polls/index"    
  end
end
