class AddColumnFacebookName < ActiveRecord::Migration
  def up
  	add_column :facebooks, :name, :string, :default=>""
  	
  	User.all.each do |u|
  		u.facebook.name = u.facebook.profile.name
  		u.facebook.save!
  	end
  	
  	
  end

  def down
  	remove_column :facebook, :name
  end
end
