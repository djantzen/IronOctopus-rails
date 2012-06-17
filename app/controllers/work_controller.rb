class WorkController < ApplicationController
  
  include LogUtils
  include StringUtils
  respond_to :json, :html

  def index
    wtf params
  end

  def create
    wtf params
    response_hash = {}
    work_hashes = params[:_json]
    work_hashes.each do |work_hash|
      begin
        user = User.find_by_login(params['user_id'])
        activity = Activity.find_by_name(work_hash['activity'])
        routine = user.routines.find_by_name(work_hash['routine'])
        measurement_key = {
                            :resistance => work_hash['resistance']
                          }
        measurement = Measurement.find_or_create(measurement_key)
        day = Day.find_or_create(work_hash['start_time'])
        
        work = Work.new(:user => user, :activity => activity, :measurement => measurement,
                        :repetitions => work_hash['repetitions'],
                        :routine => routine, :start_time => work_hash['start_time'], :end_time => work_hash['end_time'],
                        :start_day => day)
        wtf work 
        work.save
        response_hash[work_hash['start_time']] = true
      rescue Exception => e
        response_hash[work_hash['start_time']] = false
      end
    end

    respond_with do |format|
      format.html { render :html => nil }
      format.json { render :json => response_hash }
    end

  end

  def show
    wtf params
  end
  
end
