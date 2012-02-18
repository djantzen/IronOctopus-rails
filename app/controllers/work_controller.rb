class WorkController < ApplicationController
  
  def index
    raise params.inspect
  end

  def create
    puts "PARAMS #{params.inspect}"
  end

  # GET /activities/1.json
  def show
    puts params.inspect
    activity = Activity.find(params[:id])
    
    render :json => 'success'
  end
#  def show

#  end
  
end
