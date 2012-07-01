class Routine < ActiveRecord::Base

  belongs_to :trainer, :class_name => 'User', :foreign_key => 'trainer_id'
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  belongs_to :client, :class_name => 'User', :foreign_key => 'client_id'
 
  has_many :activities, :through => :activity_sets
  has_many :measurements, :through => :activity_sets
  has_many :activity_sets, :order => :position
  
end
