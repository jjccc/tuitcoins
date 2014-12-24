class AddTweetToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :tweet, :string, :null => true, :limit => 140
  end
end
