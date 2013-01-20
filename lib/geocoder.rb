require 'graticule'
#require 'geoip'

class Geocoder

  @@google_key = "ABQIAAAAN1TD9wHFlWUjOX1am1scdBTJQa0g3IQ9GZqIMmInSLzwtGDKaBT40ZpGwPaaSkIpqSJ8MxZUQehKdw"
  @@logger = Rails.logger
  @@services = [ Graticule.service(:google).new(@@google_key)]
                #, Graticule.service(:yahoo).new("i5i6wjPIkY0UaZT8OnLwbZIXbAnG")]
  
  # Ordered array of symbols corresponding to precision from most to least precise.  
  # These match Graticule's precision symbols.
  @@precisions = [
    :address, # Address level accuracy.
    :street,  # Intersection level accuracy.
    :zip,     # Post code (zip code) level accuracy. 
    :city,    # Town (city, village) level accuracy. 
    :state,   # Region (state, province, prefecture, etc.) 
    :country, # Country level accuracy.
    :unknown  # Unknown location. 
  ]

  # Expects symbols or strings corresponding to items in the precisions array.  Returns true if the precision is
  # equal to or greater than the min_precision.
  def self.precise?(min_precision, precision)
    return @@precisions.index(precision.name) <= @@precisions.index(min_precision)
  end

  # Basic sanity checks since Google sometimes claims to have matched an address even though it's in the wrong
  # city and state.
  def self.remotely_correct_at_all?(addr, loc)
    # if we only have a partial address, accept whatever geocoder gives us
    return true unless (addr[:postal_code] and addr[:region]) or (addr[:locality] and addr[:region])
    # if we have a zipcode and it matches what geocoder gives us, it's good
    return true if addr[:postal_code] and addr[:postal_code] == loc.postal_code
    # if we have a city and state and it matches what geocoder gives us, it's good
    return true if addr[:locality] and addr[:region] and addr[:locality] == loc.locality and addr[:region] == loc.region
    
    # okay, looks like none of the primary data points match, so fall back to a distance calculation based on zipcode or city and state
    return true if addr[:postal_code] and loc.distance_to(@@services.first.locate({:postal_code => addr[:postal_code]})) < 25
    return true if addr[:locality] and addr[:region] and 
      loc.distance_to(@@services.first.locate({:locality => addr[:locality], :region => addr[:region]})) < 25
    
    return false
  end

  def self.geocode_address_cached(addr, min_precision = :zip)
    cache_key = [:country, :locality, :postal_code, :region, :street].inject(min_precision.to_s) { |cache_key, addr_key| cache_key + ':' + addr[addr_key].to_s }.gsub(/ /, '_')
    Rails.cache.fetch(cache_key) { geocode_address(addr, min_precision) }
  end
  
  # Takes an address and geocodes it, returning a Location object.  The address should
  # be a hash like so: {:street=>'3rd Street & Mission Rock', :locality=>'San Francisco', :region=>'CA', :postal_code=>'94105'}.
  # If a particular precision is required it may be passed in as a symbol from the @@precisions map.
  def self.geocode_address(addr, min_precision = :zip)
    raise ArgumentError.new('First parameter must be a hash such as: ' + 
       "{:street=>'3rd Street & Mission Rock', :locality=>'San Francisco', :region=>'CA', :postal_code=>'94105'}") unless addr.instance_of?(Hash)
#    addr.validate(:street, :locality, :region, :postal_code, :country)
       
    return nil if addr.values.empty?
    
    locations = []
    # loop over all the geocoding services
    for s in @@services do
      begin
        loc = s.locate(addr)
        unless loc.nil?
          unless remotely_correct_at_all?(addr, loc)
            @@logger.warn "#{s} gave completely incorrect response of #{loc.inspect} for input #{addr.inspect}"
            next
          end
          # if the precision of the geocode is sufficient, return the location.
          if precise?(min_precision, loc.precision)
            return loc
          else
            @@logger.warn "#{s} gave insufficient '#{loc.precision}' precision geocode for #{addr}"
            locations.push(loc)
          end
        end
      rescue SocketError => se
        @@logger.error "Unable to connect to #{s} due to #{se.message}"
      rescue Exception => e
        @@logger.warn "#{s} was unable to geocode #{addr.to_yaml} due to #{e.message}"
      end
    end
    @@logger.error "Unable to geocode '#{addr.to_yaml}'" if locations.empty?
    # sort the locations by precision and return the most precise
    return locations.sort{ |a, b| @@precisions.index(a.precision) <=> @@precisions.index(b.precision) }[0]
  end

  # Takes a venue and attempts to geocode its address.
  def self.geocode_venue(venue)
    loc = nil
    if venue.is_default?
      loc = geocode_address_cached({ :locality => venue.city_name, :region => venue.state_abbr, :postal_code => venue.zipcode })  
    else
      loc = geocode_address_cached({ :street => venue.street_address, :locality => venue.city_name, 
                              :region => venue.state_abbr, :postal_code => venue.zipcode }, :address)
      loc = geocode_address_cached({ :locality => venue.city_name, :region => venue.state_abbr, 
                              :postal_code => venue.zipcode }) if loc.nil?   
    end
    
    unless loc.nil?
      venue.latitude = loc.latitude
      venue.longitude = loc.longitude
      venue.geocode_precision = loc.precision.to_s
      venue.city = City.find_by_name_and_state(loc.locality, loc.region, false) if venue.city.nil?
    end  
    return venue   
  end

  # Takes a user and attempts to geocode its address.
  def self.geocode_user(user)
    loc = geocode_address_cached({:postal_code => user.zipcode})
    unless loc.nil?
      user.latitude = loc.latitude
      user.longitude = loc.longitude      
    end
    return user   
  end

  #takes an IP address (or site name) and returns a map with city, state, zipcode, latitude and longitude.
  def self.ip_address_to_location(address)
    @@geoip ||= GeoIP.new('db/data/GeoLiteCity.dat')
    city = @@geoip.city(address)
    { :city => city[7], :region => city[6], :postal_code => city[8], :latitude => city[9], :longitude => city[10] }
  end
  
  # takes an IP address (or site name) and returns an array of City and nearest Area.
  def self.ip_address_to_nearest_metro(address)
    return [] if address.to_s.empty?
    loc = ip_address_to_location(address)
    city = City.find_by_name_and_state(loc[:city], loc[:region])
    @@logger.warn("Unable to locate city from #{address}") and return [] unless city
    area = city.nearest_area
    [city, area]
  end
  
end
