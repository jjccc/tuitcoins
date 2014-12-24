class AddFieldsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :is_active, :boolean, :null => false, :default => false
    add_column :campaigns, :period, :integer, :null => false, :default => 1
    add_column :campaigns, :unity, :integer, :null => false, :default => 3
    add_column :campaigns, :start_at, :datetime, :null => true
    add_column :campaigns, :is_default, :boolean, :null => false
  end
end
