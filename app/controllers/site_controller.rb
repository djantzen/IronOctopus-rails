class SiteController < ApplicationController

  def index
    @clients = current_user.clients.order(:last_name, :first_name)
    @routines = current_user.routines_created
    @activities = Activity.find(:all, :order => :name)
    @implements = Implement.find(:all, :order => :name)
    @work = Work.find(:all, :conditions => { :user_id => current_user })
  end

end
