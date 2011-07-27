class Resource < ActiveRecord::Base 

  belongs_to :location
  has_many :resource_practices
  has_many :resource_assignments, :dependent => :destroy
  has_many :resource_skills, :dependent => :delete_all
  has_many :skills, :through => :resource_skills
  belongs_to :vendor
  belongs_to :user

  #validates_presence_of :name, :vendor
  
  # Note level is not required, but if present must be an integer.
  # We could add this to an Exist specific resource definition - but for now we'll assume we can put all vendor resources on the same scale
  #validates_numericality_of :level, :only_integer => true, :greater_than => 0, :allow_nil => true
  
  def to_s
    return user.name
  end
  
  # The target utilization is a percentage to which the resource should be allocated
  def target_utilization
    target_allocation = TargetAllocation.find_by_level(level)
    if target_allocation
      return target_allocation.percentage_allocation
    else
      return 100
    end
  end
  
  # The billable utilization is the total billable allocation for all projects
  # at this point in time divided by the target allocation
  def billable_utilization(date=Date.today)
(resource_assignments.in_date_range(date,date).to_a.sum(&:billable_allocation)/target_utilization)*100
  end
  
  # The billable allocation is the total billable allocation for all projects
  # at this point in time
  def billable_allocation(date=Date.today)
    resource_assignments.in_date_range(date,date).to_a.sum(&:billable_allocation)
  end
  
  # The current allocation is the total allocation for all projects
  # at this point in time
  def allocation(date=Date.today)
    resource_assignments.in_date_range(date,date).to_a.sum(&:percentage_allocation)
  end
  
  def active(date=Date.today)
    ((!start_date || start_date<=date) && (!end_date || end_date>=date))
  end

  def self.not_assigned_to(sow)
    if !sow.resource_assignments.empty?
      cond = ["users.status = 1 and resources.id NOT IN (?)", sow.resource_assignments.collect {|ra| ra.resource_id}]
    else
      cond = ["users.status = 1"]
    end
    Resource.find(:all, :include => [:user], :conditions => cond)
  end

  def self.not_in_practice(practice)
    if !practice.resource_practices.empty?
      cond = ['resources.id NOT IN (?) and users.status != 3',practice.resource_practices.collect {|rp| rp.resource_id}]
    else
      cond = ['users.status != 3']
    end
    Resource.find(:all, :include => [:user], :conditions => cond)
  end

  def self.with_no_skill(skill)
    if !skill.resource_skills.empty?
      cond = ['resources.id NOT IN (?) and users.status != 3',skill.resource_skills.collect {|rs| rs.resource_id}]
    else
      cond = ['users.status != 3']
    end
    Resource.find(:all, :include => [:user], :conditions => cond)
  end
  
  def allocated_resource_by_day?(date=Date.today)
    allocated = false
    for resource_assignment in resource_assignments
		if ((!resource_assignment.start_date.nil? && resource_assignment.start_date <= date) &&  (!resource_assignment.end_date.nil? ? resource_assignment.end_date >=date : true))
        allocated = true  
        break
      end  
    end
  return allocated   
  end

  def allocated_resource_by_month?(date=Date.today)
    allocated = false
    for resource_assignment in resource_assignments
      if ((!resource_assignment.start_date.nil? && (resource_assignment.start_date.year <= date.year && resource_assignment.start_date.month <= date.month)) && (resource_assignment.end_date.nil? || resource_assignment.end_date.year > date.year || (resource_assignment.end_date.year == date.year && resource_assignment.end_date.month >= date.month)))
        allocated = true  
        break
      end  
     end  
  return allocated   
  end


  def unallocated_resource_by_month?(date=Date.today)
    resource_assignments.each do |resource_assignment|
      if ((!resource_assignment.start_date.nil? && (resource_assignment.start_date.year <= date.year && resource_assignment.start_date.month <= date.month)) &&
          (resource_assignment.end_date.nil? || resource_assignment.end_date.year > date.year || (resource_assignment.end_date.year == date.year && resource_assignment.end_date.month >= date.month)) &&
          (resource_assignment.percentage_allocation >= 100) && 
          !resource_assignment.is_shadow)
          return false;
      end
     end
  return true
  end

  def unallocated_resource_by_day?(date=Date.today)
    resource_assignments.each do |resource_assignment|
		if ((!resource_assignment.start_date.nil? && resource_assignment.start_date <= date) &&
        (!resource_assignment.end_date.nil? ? resource_assignment.end_date >=date : true) &&
        (resource_assignment.percentage_allocation >= 100) &&
        !resource_assignment.is_shadow)
          return false
      end
    end
    return true
  end

	
  def overloaded?
    total_pct_allocation = 0
    resource_assignments.find(:all, :conditions => ["start_date <= ? AND end_date >= ?", Date.today, Date.today]).each {|ra| total_pct_allocation+=ra.percentage_allocation}
    if total_pct_allocation > 100
      return true
    else
      return false
    end
  end

end
