class CreateResourcePractices < ActiveRecord::Migration
  def self.up
    create_table "resource_practices", :force => true do |t|
      t.column "resource_id", :integer
      t.column "practice_id", :integer
    end
  end

  def self.down
    drop_table :resource_practices
  end
end
