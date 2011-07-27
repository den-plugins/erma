class PracticesController < ApplicationController
  helper :resources
  include ResourcesHelper

  def index
    @practices = Practice.find(:all, :order => 'name')
  end

  def add
    @practice = Practice.new
    if request.post?
      @practice = Practice.new(params[:practice])
      if @practice.save
        redirect_to :action => 'index'
      end
    end
  end

  def show
    @practice = Practice.find(params[:id])
    @resource_practices = @practice.resource_practices.sort{|a,b| a.resource.user <=> b.resource.user}
  end

  def edit
    @practice = Practice.find(params[:id])
  end

  def update
    @practice = Practice.find(params[:id])
    if @practice.update_attributes(params[:practice])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'index'
    else
      flash[:error] = "Unsuccessful update."
      redirect_to :action => 'edit', :id => @practice.id
    end
  end

  def destroy
    @practice = Practice.find(params[:id])
    @practice.resource_practices.each {|rp| rp.destroy}
    @practice.destroy
    redirect_to :action => 'index'
  end

  def add_resource
    resource = Resource.find(params[:resource][:id])
    resource_practice = ResourcePractice.new
    resource_practice.practice = Practice.find(params[:id])
    resource_practice.resource = resource
    if request.post? && resource_practice.save
        flash[:notice] = l(:notice_successful_create)
        render(:update) do |page|
          page.redirect_to(:action => 'index')
        end
    end
  end
end