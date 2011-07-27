class ResourceAssignmentsController < ApplicationController
  helper :resources
  include ResourcesHelper
  
  def index
    @resource_assignments = ResourceAssignment.find(:all)
  end

  def add
    @resource_assignment = ResourceAssignment.new
    if params[:sow]
      @resource_assignment.statement_of_work = StatementOfWork.find(params[:sow])
      if params[:dummy]
        create_dummy
        @resources = [@user.resources.last]
      else
        @resources = Resource.not_assigned_to(@resource_assignment.statement_of_work)
      end
    else
      @resources = Resource.all
    end

    if request.post?
      @resource_assignment = ResourceAssignment.new(params[:resource_assignment])
      if @resource_assignment.save
        @member = Member.new
        @member.user = @resource_assignment.resource.user
        @member.project = @resource_assignment.statement_of_work.project
        @member.role = Role.find(:first, :conditions => { :name => @resource_assignment.role })
        @member.save
        redirect_to :controller => 'statement_of_works', :action => 'show', :id => @resource_assignment.statement_of_work.id
      end
    end
  end

  def edit
    @resource_assignment = ResourceAssignment.new
    @resources = Resource.all
    if params[:resource_assignment]
      @resource_assignment = ResourceAssignment.new(params[:resource_assignment])
    else
      @resource_assignment = ResourceAssignment.find(params[:id])
      @resources = Resource.not_assigned_to(@resource_assignment.statement_of_work)
    end
  end

  def update
    temp_resource_holder = ResourceAssignment.find(params[:id]).resource
    if ResourceAssignment.update(params[:id], params[:resource_assignment])
      temp_resource_holder.destroy if params[:dummy]
      redirect_to :controller => 'statement_of_works', :action => 'show', :id => params[:resource_assignment][:statement_of_work_id]
    else
      redirect_to :back
    end
  end

  def destroy
    @resource_assignment = ResourceAssignment.find(params[:id])
    if params[:dummy]
      @resource_assignment.resource.destroy
    end
    @resource_assignment.destroy
    @member = Member.find(:first, :conditions => {:user_id => @resource_assignment.resource.user.id, :project_id => @resource_assignment.statement_of_work.project.id})
    if !@member.nil?
      @member.destroy
    end
    redirect_to :back
  end
  
  protected
  
  def create_dummy
    @user = User.find(:first, :conditions => ["login = 'dummyuser'"])
    
    if @user.nil?
      @user = Dummy::User.new(:firstname => "Dummy", :lastname => "Resource", 
                              :mail=> "dummy@user.dummymail", :status => 3)
      @user.admin = false
      @user.login = "dummyuser"
      @user.password, @user.password_confirmation = "dummyuser", "dummyuser"
      @user.save
      
    end
    
    if @user.resources.empty? || !@user.resources.last.resource_assignments.empty?
      @resource = Resource.new
      @resource.user = @user
      @user.resources << @resource
    end
  end
end
