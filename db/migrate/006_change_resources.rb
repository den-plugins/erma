class ChangeResources < ActiveRecord::Migration
  def self.up
    remove_column :resources, :practice_id;
    add_column(:resources, :start_date, :date) unless Resource.column_names.include?('start_date')
    add_column(:resources, :end_date, :date) unless Resource.column_names.include?('end_date')
  end

  def self.down
    add_column :resources, :practice_id, :integer;
    remove_column(:resources, :start_date, :date) unless !Resource.column_names.include?('start_date')
    remove_column(:resources, :end_date, :date) unless !Resource.column_names.include?('end_date')
  end
end
