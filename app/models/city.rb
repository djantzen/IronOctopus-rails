class City < ActiveRecord::Base

  default_scope select((column_names - ['the_geom']).map { |column_name| "#{table_name}.#{column_name}"})

  belongs_to :state

  def timezone
    sql = "select timezones.* from cities join " +
          "timezones on (st_within(cities.the_geom, timezones.the_geom)) " +
          "where cities.city_id = #{self.city_id}"
    Timezone.find_by_sql(sql).first
  end

  def self.find_by_name_and_state(city_name, state_name)
    return nil if city_name.nil? or state_name.nil?
    city_name.strip!
    state_name.strip!
    cities = City.joins(:state).where("cities.name = ? and states.name = ?", city_name, state_name)

    #city = City.where("cities.name ='#{name}' and states.name='#{state}'") \
    #           .joins("inner join states using(state_id)").first
    cities.first
  end

end
