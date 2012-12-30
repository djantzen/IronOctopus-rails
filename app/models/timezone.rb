class Timezone < ActiveRecord::Base

  default_scope select((column_names - ['the_geom']).map { |column_name| "#{table_name}.#{column_name}"})

end
