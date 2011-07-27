class StatementOfWorkStatusesController < ApplicationController

  def index
    @statuses = StatementOfWorkStatus.find(:all)
  end

  def add
    @status = StatementOfWorkStatus.new(params[:status])
    if request.post? && @status.save
  	  respond_to do |format|
        format.html do
          flash[:notice] = l(:notice_successful_create)
          redirect_to :action => 'index'
        end
        format.js do
          # IE doesn't support the replace_html rjs method for select box options
          render(:update) {|page| page.replace "sow_statement_of_work_status_id",
            content_tag('select', '<option></option>' + options_from_collection_for_select(StatementOfWorkStatus.find(:all), 'id', 'name', @status.id), :id => 'sow_statement_of_work_status_id', :name => 'sow[statement_of_work_status_id]')
          }
        end
      end
    end
  end

  def edit
    @status = StatementOfWorkStatus.find(params[:id])
  end

  def update
    if StatementOfWorkStatus.update(params[:id], params[:status])
      redirect_to :action => 'index'
    end
  end

  def destroy
    @status = StatementOfWorkStatus.find(params[:id])
    @status.destroy
    redirect_to :action => 'index'
  end
end
