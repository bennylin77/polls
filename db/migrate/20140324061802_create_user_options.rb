class CreateUserOptions < ActiveRecord::Migration
  def change
    create_table :user_options, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8'  do |t|
      t.integer :user_id
      t.integer :poll_option_id 
      t.string  :src_ip     
      t.timestamps
    end
  end
end
