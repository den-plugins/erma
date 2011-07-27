class AddIsShadowOnResourceAssignment < ActiveRecord::Migration
  def self.up
    add_column :resource_assignments, :is_shadow, :boolean, :default => false
  end

  def self.down
    remove_column :resource_assigments, :is_shadow
  end

end
