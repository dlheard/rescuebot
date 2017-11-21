class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.string  :username
      t.string  :content
      t.string  :time
      t.timestamps
    end
  end
end
