class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
   	  # primary key default as :id
      t.string  :username
      t.string  :avatar_url, :default => "https://i.pinimg.com/736x/5d/a0/8d/5da08d24bc4c7d2847ee5dfa1604b114--naruto-shippudden-naruto-pics.jpg"
      t.string  :email
      t.string  :password_digest

      t.timestamps
    end
  end
end
