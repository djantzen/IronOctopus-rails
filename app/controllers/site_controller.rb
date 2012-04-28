class SiteController < ApplicationController

  def index
    @clients = current_user.clients.order(:last_name, :first_name)
    
  end

end
