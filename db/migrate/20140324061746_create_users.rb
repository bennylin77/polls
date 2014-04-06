class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string     :email
      t.integer    :age
      t.attachment :icon
      t.timestamps
    end
  end
end
