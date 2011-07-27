class StatementOfWorksController < ApplicationController

  def index
    @sows = StatementOfWork.find(:all)
  end

  def add
    @sow = StatementOfWork.new
    @projects = Project.without_sow.sort{|a,b| a.name.downcase <=> b.name.downcase}
    if request.post?
      @sow = StatementOfWork.new(params[:sow])
      if @sow.save
        redirect_to :controller => 'clients', :action => 'show', :id => @sow.client.id
      end
    else
      if params[:client]
        @sow.client = Client.find(params[:client])
      end
    end
  end

  def edit
    @sow = StatementOfWork.find(params[:id])
    @projects = Project.without_sow
    @projects << @sow.project
    @projects.sort{|a,b| a.name.downcase <=> b.name.downcase}
  end

  def update
    if StatementOfWork.update(params[:id], params[:sow])
      redirect_to :action => 'show', :id => params[:id]
    end
  end

  def destroy
    @sow = StatementOfWork.find(params[:id])
    @sow.destroy
    redirect_to :controller => 'clients', :action => 'show', :id => @sow.client.id
  end

  def show
    @sow = StatementOfWork.find(params[:id])
  end
end
