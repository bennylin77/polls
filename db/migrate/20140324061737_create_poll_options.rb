class CreatePollOptions < ActiveRecord::Migration
  def change
    create_table :poll_options, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :title
      t.integer :poll_id
      t.timestamps
    end
  end
end
