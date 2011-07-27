class VendorsController < ApplicationController
  before_filter :require_admin

  def index
    @vendors = Vendor.find(:all, :order => 'name')
  end

  def add
    @vendor = Vendor.new
    if request.post?
      @vendor = Vendor.new(params[:vendor])
      if @vendor.save
        redirect_to :action => 'index'
      end  
    end
  end

  def edit
    @vendor = Vendor.find(params[:vendor])
  end

  def update
    @vendor = Vendor.find(params[:id])
    if @vendor.update_attributes(params[:vendor])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'index'
    else
      flash[:error] = "Unsuccessful update."
      redirect_to :action => 'edit', :vendor => @vendor
    end
  end

  def destroy
    @vendor = Vendor.find(params[:vendor])
    @vendor.destroy
    redirect_to :action => 'index'
  end
end
