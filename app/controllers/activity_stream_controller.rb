class ActivityStreamController < ApplicationController
  
protected
  def create_authorized?
    false
  end

  def update_authorized?
    false
  end
  
  def delete_authorized?
    false
  end
end
