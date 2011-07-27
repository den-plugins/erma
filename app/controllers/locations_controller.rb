class LocationsController < ApplicationController

  def index
    @locations = Location.find(:all, :order => 'name')
  end

  def add
    @location = Location.new(params[:location])
    if request.post? && @location.save
  	  respond_to do |format|
        format.html do
          flash[:notice] = l(:notice_successful_create)
          redirect_to :action => 'index'
        end
        format.js do
          # IE doesn't support the replace_html rjs method for select box options
          render(:update) {|page| page.replace "resource_location_id",
            content_tag('select', '<option></option>' + options_from_collection_for_select(Location.find(:all), 'id', 'name', @location.id), :id => 'resource_location_id', :name => 'resource[location_id]')
          }
        end
      end
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'index'
    else
      flash[:error] = "Unsuccessful update."
      redirect_to :action => 'edit', :id => @location.id
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    redirect_to :action => 'index'
  end
end
