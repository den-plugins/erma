class ResourceSkill < ActiveRecord::Base 
  
  belongs_to :resource
  belongs_to :skill

  validates_presence_of :resource, :skill
  validates_uniqueness_of :resource_id, :scope => :skill_id
  
  def to_s
    return skill.to_s
  end
end
