class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :type
      t.text :copy
      t.integer :likes
      t.integer :comments
      t.integer :shares
      t.datetime :date
      t.string :link
      t.integer :fb_id

      t.timestamps
    end
  end
end
