# encoding: utf-8
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
	context = "接受"
 	flag = 0
	User.find(session[:user_id]).like_options.each do |l|
		if (l.comment_id == i and type=="main") or (l.sub_comment_id == i and type=="sub")
			context = "收回"	
			flag = 1
		end
	end		
	

	return '<a href="javascript: void(0)"class="ref_main_urlive-container-acc" id="like_'+type+"_"+i.to_s+ '" onclick="_like('+"'"+type+"'"+','+i.to_s+',this);">'+context+'</a>'
end

def replybutton(i)
	html=""
	html<<'<a href="javascript: void(0)"id="reply_but_'<<i.to_s
	html<<'"class="ref_main_urlive-container-acc" onclick="show_reply('
	html<<i.to_s<<')">回覆</a>'
	
	return html
end

def editbutton(type,i)
	html=""
	html<<'<a href="javascript: void(0)" class="ref_main_urlive-container-acc" onclick="show_edit('
	html<<"'"<<type<<"','"<<i.to_s<<"'"
	html<<')">修改</a>'
	return html
end
def but_spilt_bar
 html='<span class="ref_main_urlive-container-acc">．</span>'
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
	return image_tag(usr_img_url, :class=>"img", size:"35x35")
end

def edit_textarea
	html=""
	html<<"<textarea class='field span5' rows='3' id='context_id_for_replace'>"
	html<<"content_for_replace"
	html<<"</textarea>"
	html<<"<span class='ref_post ref_button' id="
	html<<'"<%=local_assigns[:_type]%>_submit"onclick="edit('
	html<<"'id_for_replace').submit();"<<'">留言</span>'
	
	return html
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