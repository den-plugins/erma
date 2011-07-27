#TODO: consider common base class "Company" with Client so that a Vendor can be a Client

class Vendor < ActiveRecord::Base   
  
  has_many :resources
  
  validates_presence_of :name
  validates_length_of :name, :within => 3..30
  
  def count_of_resources
    return resources.count
  end
  
end