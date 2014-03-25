class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :user_id
      t.integer :kind
      t.boolean :verified_c, :default => true, :null => false     
      t.string :title
      t.text :description      
      t.timestamps
    end
  end
end
