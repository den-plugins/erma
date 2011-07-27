class ClientsController < ApplicationController

  def index
    @clients = Client.find(:all, :order => 'name')
  end

  def add
    @client = Client.new
    if request.post?
      @client = Client.new(params[:client])
      if @client.save
        redirect_to :action => 'index'
      end
    end
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(params[:client])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'index'
    else
      flash[:error] = "Unsuccessful update."
      redirect_to :action => 'edit', :id => @client.id
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    redirect_to :action => 'index'
  end

  def show
    @client = Client.find(params[:id])
  end
end
