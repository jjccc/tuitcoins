class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name, :null => false
      t.string :consumer_key, :null => false
      t.string :consumer_secret, :null => false

      t.timestamps
    end
  end
end
