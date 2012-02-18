class ActivitiesController < ApplicationController
  
  def index

    activities = Activity.find(:all).map do |a|
      {
        :activity_id => a.name.gsub(/\s+/, '').downcase,
        :name => a.name, :activity_type => a.activity_type.name
      }
    end 
        
    render :json => activities 
  end

  def create
    puts "PARAMS " + params['activity']['name']
    activity = Activity.new()
    activity.name = params['activity']['name']
    activity.save
    render :json => activity
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
