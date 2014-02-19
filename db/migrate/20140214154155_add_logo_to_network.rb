class AddLogoToNetwork < ActiveRecord::Migration
  def self.up
    add_attachment :networks, :logo
  end

  def self.down
    remove_attachment :networks, :logo
  end
end
