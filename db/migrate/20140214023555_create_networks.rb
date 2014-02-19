class CreateNetworks < ActiveRecord::Migration
  def change
    create_table :networks do |t|
      t.string :fb_id
      t.string :name
      t.integer :fb_fans

      t.timestamps
    end
  end
end
