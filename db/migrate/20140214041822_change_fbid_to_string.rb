class ChangeFbidToString < ActiveRecord::Migration
  def change
  	change_column :posts, :fb_id, :string
  end
end
