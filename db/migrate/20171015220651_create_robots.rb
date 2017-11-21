class CreateRobots < ActiveRecord::Migration[5.1]
  def change
    create_table :robots do |t|
    	t.string :robot_url 
    	t.integer  :available, :default => 0#bool 1 if available and 0 if not
    	t.integer :lon, :default => -1
    	t.integer :lat,  :default => -1

      t.timestamps
    end
  end
end
