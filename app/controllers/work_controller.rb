class WorkController < ApplicationController
  
  include LogUtils
  include StringUtils
  
  def index
    wtf params
  end

  def create
    user = User.find_by_login(params['login'])
    activity = Activity.find_by_name(params['activity'])
    routine = user.routines.find_by_name(params['routine'])
    measurement_key = {
                        :resistance => params['resistance']
                      }
    measurement = Measurement.find_or_create(measurement_key)
    day = Day.find_or_create(params['start_time'])
    
    work = Work.new(:user => user, :activity => activity, :measurement => measurement,
                    :repetitions => params['repetitions'],
                    :routine => routine, :start_time => params['start_time'], :end_time => params['end_time'],
                    :start_day => day)
    wtf work 
    
    work.save
    render :json => work
  end

  def show
    wtf params
  end
  
end
