class Neighborhood < ActiveRecord::Base

  default_scope select((column_names - ['the_geom']).map { |column_name| "#{table_name}.#{column_name}"})

  belongs_to :city
  belongs_to :state

  has_and_belongs_to_many :locations, :join_table => 'locations_neighborhoods', :delete_sql => ''

end