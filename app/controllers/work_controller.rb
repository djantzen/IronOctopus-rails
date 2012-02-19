class WorkController < ApplicationController
  
  include LogUtils
  include StringUtils
  
  def index
    raise params.inspect
  end

  def create
    wtf(params)
    user = User.find_by_login(params['login'])
    activity = Activity.find_by_name(params['activity'])
    measurement_key = {
                          :resistance => params['resistance'],
                          :repetitions => params['repetitions']
                        }
    
    routine = user.routines.find_by_name(params['routine'])
    measurement = Measurement.find_or_create(measurement_key)
    
    work = Work.new
    work.user = user
    work.activity = activity
    work.measurement = measurement
    work.routine = routine
    work.start_time = params['start_time']
    work.end_time = params['end_time']
    work.start_day = Day.find_or_create(params['start_time'])
    wtf(work)
    
    work.save
  end

  def show

  end
  
end
