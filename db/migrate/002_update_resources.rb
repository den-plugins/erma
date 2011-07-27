class UpdateResources < ActiveRecord::Migration
  def self.up
    remove_column :resources, :name
    remove_column :resources, :email
    remove_column :resources, :phone
    add_column    :resources, :user_id, :integer
  end

  def self.down
    add_column    :resources, :name
    add_column    :resources, :email
    add_column    :resources, :phone
    remove_column :resources, :user_id, :integer
  end
end
