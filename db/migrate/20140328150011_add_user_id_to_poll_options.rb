class AddUserIdToPollOptions < ActiveRecord::Migration
  def change
    add_column :poll_options, :user_id, :integer    
  end
end
