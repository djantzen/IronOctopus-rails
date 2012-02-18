class Work < ActiveRecord::Base
  
  set_table_name 'work'
  
  belongs_to :routine
  belongs_to :user
  belongs_to :activity
  belongs_to :measurement
  
end
