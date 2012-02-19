class Routine < ActiveRecord::Base

  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
 
  has_many :activities, :through => :activity_sets
  has_many :measurements, :through => :activity_sets
  has_many :activity_sets

  include StringUtils

  def natural_id
    as_identifier(name)
  end
  
end
