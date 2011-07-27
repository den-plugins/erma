class SkillsController < ApplicationController
  helper :resources
  include ResourcesHelper

  def index
    @skills = Skill.find(:all, :order => 'name')
  end

  def add
    @skill = Skill.new
    if request.post?
      @skill = Skill.new(params[:skill])
      if @skill.save
        redirect_to :action => 'index'
      end
    end
  end

  def show
    @skill = Skill.find(params[:id])
    @resource_skills = @skill.resource_skills.sort{|a,b| a.resource.user <=> b.resource.user}
  end

  def edit
    @skill = Skill.find(params[:id])
  end

  def update
    @skill = Skill.find(params[:id])
    if @skill.update_attributes(params[:skill])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'index'
    else
      flash[:error] = "Unsuccessful update."
      redirect_to :action => 'edit', :id => @skill.id
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    @skill.resource_skills.each {|rs| rs.destroy}
    @skill.destroy
    redirect_to :action => 'index'
  end

  def add_resource
    resource = Resource.find(params[:resource][:id])
    resource_skill = ResourceSkill.new
    resource_skill.skill = Skill.find(params[:id])
    resource_skill.resource = resource
    if request.post? && resource_skill.save
        flash[:notice] = l(:notice_successful_create)
        render(:update) do |page|
          page.redirect_to(:action => 'index')
        end
    end
  end
end
