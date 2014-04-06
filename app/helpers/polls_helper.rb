module PollsHelper

def usr_page(username,userid)
	return link_to(username,"http://www.facebook.com/"+userid)
end
def reply_table_whole_span
	return "span12"
end

def reply_table_content_span
	return "span6"
end
def likebutton(type,i)
	context = "讚"
 	flag = 0
	User.find(session[:user_id]).like_options.each do |l|
		if (l.comment_id == i and type=="main") or (l.sub_comment_id == i and type=="sub")
			context = "收回讚"	
			flag = 1
		end
	end		
	

	return '<button id="'+type+"_"+i.to_s+'"class="btn btn-mini btn-primary disabled" type="button"' +'onclick="_like('+"'"+type+"'"+','+i.to_s+',this);">'+context+'</button>'
end

def replybutton(i)
	html=""
	html<<'<button class="btn btn-mini btn-primary disabled" type="button" onclick="show_reply('
	html<<i.to_s
	html<<')">回覆</button>'
	return html
end

def reply_left_border_css(poll_id,poll_option_id)
	html=""
	html<<"solid 6px "
	html<<get_color(poll_id,poll_option_id)
	return html
end

def reply_usr_td_main_content
	return "<td class='span6' >"
end

def usr_img_tag(usr_img_url)
	return image_tag(usr_img_url)
end

def reply_textarea
	return "<textarea class='field span3' placeholder='我要留言...' rows='3' ></textarea><button class='btn btn-mini disabled' type='button' onclick='_subreply(this);' >送出</button>"
	
end

def get_color(poll_id,poll_option_id)
    if poll_option_id.blank?
    	return "transparent" 
    end
	
  	Poll.find(poll_id).poll_options.order("id ASC").each_with_index do |o, index|
  		if poll_option_id == o.id
  			return Polls::Application.config.chartcolor[index]
  		end
  	end
  	return "transparent"   
end

end