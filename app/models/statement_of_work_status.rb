class StatementOfWorkStatus < ActiveRecord::Base   
  
  has_many :statement_of_works, :class_name => "StatementOfWork"
end
