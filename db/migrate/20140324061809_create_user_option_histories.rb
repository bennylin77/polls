class CreateUserOptionHistories < ActiveRecord::Migration
  def change
    create_table :user_option_histories, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :user_option_id
      t.integer :poll_option_id 
      t.timestamps
    end
  end
end
