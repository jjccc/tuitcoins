class AddAppIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :app_id, :integer, :null => false, :default => 1
  end
end
