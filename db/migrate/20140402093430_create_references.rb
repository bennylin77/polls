class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :poll_id
      t.integer :user_id
      t.integer :article_id      
      t.integer :poll_option_id
      t.integer :kind      
      t.text    :link      
      t.boolean :verified_c, :default => true, :null => false                    

      t.timestamps
    end
  end
end
