class ResourceAssignment < ActiveRecord::Base
  
  belongs_to :resource
  belongs_to :statement_of_work
  
  #has_many :timesheet_entries, :dependent => :destroy
  
  validates_presence_of :resource, :start_date
  validates_presence_of :statement_of_work
  validates_presence_of :percentage_allocation
  validates_numericality_of :percentage_allocation, :integer_only => true, :greater_than_equal => 0, :less_than_equal => 100
  #validates_numericality_of :billing_rate, :integer_only => true
  validates_uniqueness_of :resource_id, :scope => :statement_of_work_id
  validate_on_create :validate_dates
  validate_on_update :validate_dates

  def to_s
    return resource ? resource.name : "INVALID RESOURCE";
  end
  
  def self.current
    in_date_range(Date.today,Date.today)
  end

  def self.in_date_range(start_date,end_date)
    find(:all, :include => [{:statement_of_work => :client}], :conditions => ["(resource_assignments.start_date is null or resource_assignments.start_date <= ? ) and (resource_assignments.end_date is null or resource_assignments.end_date>= ?) and clients.active=true",start_date,end_date])
  end  
  
  # The Billable Allocation is the percentage allocation which is being paid for,
  # note that it also considers that on-demand resources are allocated 20%
  def billable_allocation
    if (billing_rate && billing_rate>0)
      if on_demand
        return 20;
      else
        return percentage_allocation;
      end
    else
      return 0  
    end
  end

  protected
  
  def validate_dates
    if start_date && start_date < statement_of_work.start_date
      #errors.add(:start_date, "should be on or after Project's start date")
      errors.add_to_base("Start date should be on or after Project's start date")
    end

    if end_date && end_date > statement_of_work.end_date
      errors.add(:end_date, "should be on or before Project's end date")
    end
		
		if end_date && end_date < start_date
			errors.add(:end_date, "should be on or after the Resource Assignment's start date")
		end
  end
end
