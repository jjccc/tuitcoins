class AddImpressionsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :impressions, :integer, :null => false, :default => 0
  end
end
