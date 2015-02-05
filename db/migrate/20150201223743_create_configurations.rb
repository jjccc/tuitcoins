class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.string :name, :null => false
      t.string :value, :null => false

      t.timestamps
    end
  end
end
