class Practice < ActiveRecord::Base
  
  has_many :resource_practices
  
  validates_presence_of :name
  validates_length_of :name, :within => 3..30
  
  def to_s
    name
  end
  
  def percentage_allocated(date=Date.today)
    max_allocation=0
    sum_allocation=0
    resource_practices.each do |resource_practice|
       if resource_practice.resource.vendor.active==true && resource_practice.resource.active(date)
         sum_allocation += resource_practice.resource.billable_allocation(date)
         max_allocation += 100
       end
    end
    
    return ("%.2f" % ((sum_allocation.to_f/max_allocation.to_f)*100)).to_f
  end
  
  def active_resources(date=Date.today)
    resource_practices.inject([]) do |active_resources, resource_practice|
       active_resources << resource_practice.resource if resource_practice.resource.vendor.active==true && resource_practice.resource.active(date)
       active_resources
    end
  end
  
  def fully_allocated_resources(date=Date.today)
    resource_practices.inject([]) do |fully_allocated_resources, resource_practice|
       fully_allocated_resources << resource_practice.resource if resource_practice.resource.billable_allocation(date)==100 && resource_practice.resource.vendor.active==true && resource_practice.resource.active(date)
       fully_allocated_resources
    end
  end
  
  def over_allocated_resources(date=Date.today)
    resource_practices.inject([]) do |fully_allocated_resources, resource_practice|
       fully_allocated_resources << resource_practice.resource if resource_practice.resource.billable_allocation(date)>100 && resource_practice.resource.vendor.active==true && resource_practice.resource.active(date)
       fully_allocated_resources
    end
  end
  
  def partially_allocation_resources(date=Date.today)
    resource_practices.inject([]) do |partially_allocation_resources, resource_practice|
       partially_allocation_resources << resource_practice.resource if resource_practice.resource.billable_allocation(date)<100 && resource_practice.resource.billable_allocation(date)>0 && resource_practice.resource.vendor.active==true && resource_practice.resource.active(date)
       partially_allocation_resources
    end
  end
  
  def unallocated_resources(date, columns)
    u_resources = []
    for resource_practice in resource_practices
      case columns
        when 'month'
          u_resources << resource_practice.resource if  (resource_practice.resource.unallocated_resource_by_month?(date))
        when 'day'
          u_resources << resource_practice.resource if  (resource_practice.resource.unallocated_resource_by_day?(date))
      end
     
    end
  return u_resources
  end
  
end