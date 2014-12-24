class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :category_id
      t.string :link

      t.timestamps
    end
  end
end
