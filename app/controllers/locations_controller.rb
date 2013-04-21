class LocationsController < ApplicationController
  before_filter :authenticate_user
  def new
    @location = Location.new
  end

  def create
    city_name, state_name = params[:city].split(",")
    city = City.find_by_name_and_state(city_name, state_name)
    @location = Location.new(params[:location])
    @location.city = city
    @location.save
  end

  def edit
    @location = Location.find_by_permalink(params[:id])
  end

  def update
    city_name, state_name = params[:city].split(",")
    city = City.find_by_name_and_state(city_name, state_name)
    @location = Location.find_by_permalink(params[:id])
    @location.street_address = params[:location][:street_address]
    @location.city = city
    @location.postal_code = params[:location][:postal_code]
    @location.category = params[:location][:category]
    @location.save
  end

  def show
    @location = Location.find_by_permalink(params[:id])
  end

  def index
    @locations = Location.all
  end

  private
  def create_or_update(location)
    city_name, state_name = params[:city].split(",")
    city = City.find_by_name_and_state(city_name, state_name)
    @location = Location.new(params[:location])
    @location.city = city
    @location.save
  end

end
