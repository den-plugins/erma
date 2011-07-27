class RenameStatementsOfWorkTable < ActiveRecord::Migration
  def self.up
    begin
      if !StatementOfWork.table_exists?
        rename_table :statements_of_work, :statement_of_works
      end
    rescue
      drop_table :statements_of_work
    end
  end

  def self.down
    rename_table :statement_of_works, :statements_of_work
  end
end
