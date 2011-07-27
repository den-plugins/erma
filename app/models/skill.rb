class Skill < ActiveRecord::Base

  has_many :resource_skills
  
  validates_presence_of :name
  validates_length_of :name, :within => 3..30
  
  def to_s
    return name
  end
end
