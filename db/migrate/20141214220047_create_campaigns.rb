class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.integer :user_id
      t.integer :plan_id

      t.timestamps
    end
  end
end
