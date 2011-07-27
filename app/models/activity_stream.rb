class ActivityStream < ActiveRecord::Base   
  
  set_table_name "activity_stream"
  validates_presence_of :description, :login, :action
end
