class UpdateStatementsOfWork < ActiveRecord::Migration

  def self.up
    add_column :statements_of_work, :project_id, :integer
    remove_column :statements_of_work, :name
    remove_column :statements_of_work, :description
  end

  def self.down
    remove_column :statements_of_work, :project_id
    add_column :statements_of_work, :name, :string
    add_column :statements_of_work, :description, :text
  end
end