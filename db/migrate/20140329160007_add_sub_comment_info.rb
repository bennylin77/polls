class AddSubCommentInfo < ActiveRecord::Migration
  def change
	create_table :sub_comments, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8'  do |t|
		t.integer :user_id
		t.integer :comment_id
		t.integer :poll_option_id
		t.text :content
		
		t.timestamps
	end
  end
end
