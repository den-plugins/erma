# DEN - project management software
# Copyright (C) 2008  Gretchen May P. Gapol
#
# This program is free software; you can redistribute it and/or
# modify it.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# 

class Setup < ActiveRecord::Migration
  
  class ActivityStream < ActiveRecord::Base; end
  
  def self.up
    create_table "clients", :force => true do |t|
      t.column "name", :string
      t.column "description", :text
      t.column "active", :boolean
    end
    
    create_table "statements_of_work", :force => true do |t|
      t.column "client_id", :integer
      t.column "statement_of_work_status_id", :integer
      t.column "name", :string
      t.column "description", :text
      t.column "start_date", :date
      t.column "end_date", :date
      t.column "hourly_billing", :boolean, :default => false
    end
    
    create_table "resources", :force => true do |t|
      t.column "name", :string
      t.column "email", :string
      t.column "phone", :string
      t.column "vendor_id", :integer
      t.column "location_id", :integer
      t.column "practice_id", :integer
      t.column "start_date", :date
      t.column "end_date", :date
      t.column "level", :integer
    end

    create_table "vendors", :force => true do |t|
      t.column "name", :string
      t.column "description", :text
      t.column "start_date", :date
      t.column "end_date", :date
      t.column "active", :boolean
    end
    
    create_table "resource_assignments", :force => true do |t|
      t.column "statement_of_work_id", :integer
      t.column "resource_id", :integer
      t.column "start_date", :date
      t.column "end_date", :date
      t.column "percentage_allocation", :integer
      t.column "billing_rate", :float
      t.column "role", :string
      t.column "on_demand", :boolean, :default => false
      t.column "locked", :boolean
    end
    
    create_table "skills", :force => true do |t|
      t.column "name", :string
    end
    
    create_table "statement_of_work_statuses", :force => true do |t|
      t.column "name", :string
    end
    
    create_table "activity_stream", :force => true do |t|
      t.column "description", :text
    end

    create_table "resource_skills", :force => true do |t|
      t.references :skill
      t.references :resource
      # TODO: consider an "experience level on the normal 1-5 scale
      t.column "notes", :string
    end
   
    create_table "locations", :force => true do |t|
      t.column "name", :string
    end

    create_table "practices", :force => true do |t|
      t.column "name", :string
    end
    
    create_table "target_allocations", :force => true do |t|
      t.column "level", :integer
      t.column "percentage_allocation", :integer
    end

    ActivityStream.transaction do
      add_column :activity_stream, :action, :string
      add_column :activity_stream, :affected_type, :string
      add_column :activity_stream, :affected_id, :integer
      add_column :activity_stream, :login, :string
    end
  end

  def self.down
    drop_table :clients
    drop_table :statements_of_work
    drop_table :resources
    drop_table :vendors
    drop_table :resource_assignments
    drop_table :skills
    drop_table :statement_of_work_statuses
    drop_table :activity_stream
    drop_table :resource_skills
    drop_table :locations
    drop_table :practices
    drop_table :target_allocations
    
    ActivityStream.transaction do
      remove_column :activity_stream, :action
      remove_column :activity_stream, :affected_type
      remove_column :activity_stream, :affected_id
      remove_column :activity_stream, :login
    end
  end
end
