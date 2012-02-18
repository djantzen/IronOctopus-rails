class User < ActiveRecord::Base
  
  has_many :routines, :class_name => 'Routine', :foreign_key => 'owner_id'

end
