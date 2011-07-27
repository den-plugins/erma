class ResourcePractice < ActiveRecord::Base

  belongs_to :resource
  belongs_to :practice

  validates_presence_of :resource, :practice
  validates_uniqueness_of :resource_id, :scope => :practice_id

  def to_s
    return practice.to_s
  end
end
