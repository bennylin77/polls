# encoding: UTF-8
class PollOptionHistory < ActiveRecord::Base
  attr_accessible :count, :poll_option_id
  attr_accessor  :chart
  belongs_to :poll_option

  def self.count_for_chart(option_list,option_cnt)
  	  tmp = 0
      flag= 0
      options =  Array.new
      row_list = Array.new
      inner_cnt = 0
      PollOptionHistory.find(:all,
                           :select=>'poll_option_id,count,DATE_FORMAT(created_at,"%Y-%m-%d %H:00") as t',
                           :conditions=>{:poll_option_id=>option_list},
                           :order=>'t asc,poll_option_id asc'
                            ).each do |pp|		 
          if tmp != pp.t
            tmp = pp.t
            if flag==1  # skip first loop       
              while  inner_cnt < option_cnt 
 				row_list << 0
 				inner_cnt = inner_cnt + 1
 			  end
              options << row_list   
              row_list = Array.new    			  
            end
            row_list << DateTime.parse(pp.t).since(8.hour)#pp.t.to_s     #first col is datetime
            flag=1 
            inner_cnt = 0 
          end
          row_list << pp.count 
          tmp = pp.t
          inner_cnt = inner_cnt + 1
      end  
      while  inner_cnt < option_cnt 
 		row_list << 0
 		inner_cnt = inner_cnt + 1
 	  end
      options << row_list
  end	

end
