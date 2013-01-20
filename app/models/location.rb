class Location < ActiveRecord::Base

  CATEGORIES = ['Athletic Club', 'Dojo', 'Studio', 'Track', 'Other']

  before_create :geocode
  after_create :set_the_geom
  belongs_to :city

  # delete_sql prevents errors during fixture teardown because they are views
  has_and_belongs_to_many :neighborhoods, :join_table => 'locations_neighborhoods', :delete_sql => ''
  has_and_belongs_to_many :areas, :join_table => 'locations_areas', :delete_sql => ''

  def geocode
    request = { :street => street_address, :locality => city.name,
                :region => city.state.name, :postal_code => postal_code }
    location = Geocoder::geocode_address(request)
    self.longitude = location.longitude
    self.latitude = location.latitude
    #point = "0x" + connection.select_value("select st_pointfromtext('POINT(#{location.longitude} #{location.latitude})')")
    #self.the_geom = point
  end

  def set_the_geom
    query = "update application.locations set the_geom = ST_PointFromText('POINT(#{longitude} #{latitude})', 4269) where location_id = #{self.location_id};"
    Location.connection.execute(query)
  end

end
