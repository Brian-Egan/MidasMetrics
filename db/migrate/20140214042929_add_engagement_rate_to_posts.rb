class AddEngagementRateToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :network_id, :integer
  	add_column :posts, :engagement, :float
  end
end
