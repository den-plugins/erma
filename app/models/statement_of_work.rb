class StatementOfWork < ActiveRecord::Base 
  
  has_many :resource_assignments, :dependent => :destroy
  belongs_to :statement_of_work_status
  belongs_to :client
  belongs_to :project
  
  validates_presence_of :project, :client, :start_date
  validate_on_create :check_date_range
  validate_on_update :check_date_range
  
  def to_s
    return project.name
  end
  
  # Very simple logical check to determine if there are or have been any billable resources
  def billable
    billable=false
    resource_assignments.each {|resource_assignment| billable=true if (resource_assignment.billing_rate && resource_assignment.billing_rate>0) }
    return billable
  end

  def check_date_range
    if start_date && end_date
      errors.add_to_base('Start date should be less than End date') unless start_date < end_date
    end
  end
end
