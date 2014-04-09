class CreateReferenceClicks < ActiveRecord::Migration
  def change
    create_table :reference_clicks, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :reference_id      
      t.integer :user_id
      t.timestamps
    end
  end
end
