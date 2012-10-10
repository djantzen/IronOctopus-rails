class SiteController < ApplicationController

  before_filter :authenticate_user

  def index
    @clients = current_user.clients.order(:last_name, :first_name)
    @routines = current_user.routines
    @programs = current_user.weekday_programs
#    @activities = Activity.all(:order => :name)
#    @implements = Implement.all(:order => :name)
    #@work = Work.all(:conditions => { :user_id => current_user })
  end

end
