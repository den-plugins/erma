class ResourcesController < ApplicationController
  include ResourcesHelper
  
  before_filter :require_admin

  def index
    limit = per_page_option
    @resource_count = Resource.find(:all,
                                    :include => [:user],
                                    :conditions => ["users.status = 1"]).size
    @resource_pages = Paginator.new self, @resource_count, limit, params['page']
    @resources = Resource.find(:all,
                               :include => [:user],
                               :conditions => ["users.status = 1"],
                               :order => "users.firstname, users.lastname",
                               :limit => limit,
                               :offset => @resource_pages.current.offset)
    respond_to do |format|
      format.html { render :template => 'resources/index.rhtml', :layout => !request.xhr?   }
    end
  end

  def add
    @resource = Resource.new
    if request.post?
      @resource = Resource.new(params[:resource])
      @resource.save
      redirect_to :action => 'index'
    end
  end

  def edit
    @resource = Resource.find(params[:resource])
  end

  def update
    if Resource.update(params[:id], params[:resource])
      redirect_to :action => 'show', :resource => params[:id]
    else
      redirect_to :back, :resource => params[:id]
    end
  end

  def show
    @resource = Resource.find(params[:resource])
    redirect_to :controller => 'account', :action => 'show', :id => @resource.user.id
  end

  def destroy
    @resource = Resource.find(params[:resource])
    @resource.resource_practices.each {|rp| rp.destroy}
    @resource.destroy
    redirect_to :action => 'index'
  end

end
  
