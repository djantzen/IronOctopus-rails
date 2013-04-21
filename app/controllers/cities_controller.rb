class CitiesController < ApplicationController

  before_filter :authenticate_user
  respond_to :json

  def search
    search_string = params[:name]
    max_results = params[:max_results] || 20
    cities = City.where("name ilike '#{search_string}%'").limit(max_results).all(:include => :state)
    results = cities.map do |city|
      [ city.name, city.state.name ]
    end

    respond_with :json => results
  end
  
end
