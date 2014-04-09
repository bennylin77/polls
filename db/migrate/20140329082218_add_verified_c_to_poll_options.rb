class AddVerifiedCToPollOptions < ActiveRecord::Migration
  def change
    add_column :poll_options, :verified_c, :boolean, default: true, null: false        
  end
end
