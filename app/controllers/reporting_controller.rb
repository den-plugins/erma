class ReportingController < ApplicationController
  helper :reporting
  include ReportingHelper
      
  def index
    engaged_projects
  end

  def engaged_projects
    @active_sows = StatementOfWork.find(:all, :conditions => ["start_date <= ? and end_date >= ?", Date.today, Date.today])
    @planned_sows = StatementOfWork.find(:all, :conditions => ["start_date > ?", Date.today])
  end

  def benched_resources
    @practice = Practice.find(params[:practice])
    period = convert_date(params[:period], params[:columns])
    @resources = @practice.unallocated_resources(period, params[:columns]).sort{|a,b| a.user <=> b.user}
  end

end
