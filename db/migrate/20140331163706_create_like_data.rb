class CreateLikeData < ActiveRecord::Migration
  def change
  	create_table :like_options, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8'  do |t|
		t.integer :user_id
		t.integer :comment_id
		t.integer :sub_comment_id
		
		t.timestamps
	end
  end
end
