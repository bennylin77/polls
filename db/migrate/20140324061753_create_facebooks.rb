class CreateFacebooks < ActiveRecord::Migration
  def change
    create_table :facebooks, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :identifier
      t.string :access_token
      t.string :username
      t.integer :user_id   
      t.timestamps
    end
  end
end
