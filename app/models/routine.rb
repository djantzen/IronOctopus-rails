class Routine < ActiveRecord::Base

  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
 
  has_many :activities, :through => :activity_sets
  has_many :measurements, :through => :activity_sets
  has_many :activity_sets

  accepts_nested_attributes_for :activity_sets, :allow_destroy => :true,
    :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  include StringUtils

  def natural_id
    as_identifier(name)
  end
  
end
