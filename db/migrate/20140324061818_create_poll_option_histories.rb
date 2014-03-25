class CreatePollOptionHistories < ActiveRecord::Migration
  def change
    create_table :poll_option_histories, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :count
      t.integer :poll_option_id   
      t.timestamps
    end
  end
end
