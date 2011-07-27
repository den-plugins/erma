class Client < ActiveRecord::Base 
  
  has_many :statement_of_works, :class_name => "StatementOfWork", :dependent => :destroy
  
  validates_presence_of :name
  validates_length_of :name, :within => 3..30
  
  def to_s
    return name
  end
end
