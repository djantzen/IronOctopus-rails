class Feedback < ActiveRecord::Base

  set_table_name 'feedback'
  belongs_to :user
end
