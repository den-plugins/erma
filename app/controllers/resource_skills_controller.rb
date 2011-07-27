class ResourceSkillsController < ApplicationController
  helper :resources
  include ResourcesHelper
  
  def add
    @resource_skill = ResourceSkill.new
    if params[:skill]
      @resource_skill.skill = Skill.find(params[:skill])
      @resources = Resource.with_no_skill(@resource_skill.skill)
    else
      @resources = Resource.all
    end
    
		
    if request.post?
      @resource_skill = ResourceSkill.new(params[:resource_skill])
      if @resource_skill.save
        flash[:notice] = l(:notice_successful_create)
        redirect_to :controller => 'skills', :action => 'show', :id => @resource_skill.skill.id
      end
    end
  end
  
  def edit
    @resource_skill = ResourceSkill.find(params[:id])
    @resources = Resource.with_no_skill(@resource_skill.skill)
  end
  
  def update
    if ResourceSkill.update(params[:id], params[:resource_skill])
      redirect_to :controller => 'skills', :action => 'show', :id => params[:resource_skill][:skill_id]
    end  
  end
  
  def destroy
    @resource_skill = ResourceSkill.find(params[:id])
    @resource_skill.destroy
    redirect_to :back
  end
  
end
