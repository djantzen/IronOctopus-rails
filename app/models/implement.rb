class Implement < ActiveRecord::Base
  has_and_belongs_to_many :activities, :class_name => 'Activity', :foreign_key => 'implement_id', :association_foreign_key => 'activity_id'
end
