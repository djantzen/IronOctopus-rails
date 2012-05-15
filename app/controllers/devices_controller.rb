class DevicesController < ApplicationController
  
  def create

    user = User.find_by_login(params[:login])
    if user && user.authenticate(params[:password])
      device = Device.new(:user => user)
      device.save
      render :json => { :uuid => device.device_uuid }.to_json, :status => 200
    else
      render :json => { :uuid => 0 }.to_json, :status => 401
    end
    
  end
  
end
