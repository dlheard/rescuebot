class CreateRobots < ActiveRecord::Migration[5.1]
  def change
    create_table :robots do |t|
    	t.string :robot_url 
    	t.integer :lon, :default => -1
    	t.integer :lat,  :default => -1

      t.timestamps
    end
  end
end
