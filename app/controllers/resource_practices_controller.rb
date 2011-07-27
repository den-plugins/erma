
class ResourcePracticesController < ApplicationController
  helper :resources
  include ResourcesHelper

  def add
    @resource_practice = ResourcePractice.new
    if params[:practice]
      @resource_practice.practice = Practice.find(params[:practice])
      @resources = Resource.not_in_practice(@resource_practice.practice)
    else
      @resources = Resource.all
    end
    
    if request.post?
      @resource_practice = ResourcePractice.new(params[:resource_practice])
      if @resource_practice.save
        flash[:notice] = l(:notice_successful_create)
        redirect_to :controller => 'practices', :action => 'show', :id => @resource_practice.practice.id
      end
    end
  end

  def edit
    @resource_practice = ResourcePractice.find(params[:id])
    @resources = Resource.not_in_practice(@resource_practice.practice)
  end

  def update
    if ResourcePractice.update(params[:id], params[:resource_practice])
      redirect_to :controller => 'practices', :action => 'show', :id => params[:resource_practice][:practice_id]
    end
  end

  def destroy
    @resource_practice = ResourcePractice.find(params[:id])
    @resource_practice.destroy
    redirect_to :back
  end
end
