class Location < ActiveRecord::Base
  
  has_many :resources
  
  validates_presence_of :name
  validates_length_of :name, :within => 3..30
  
  def to_s
    name
  end
end
