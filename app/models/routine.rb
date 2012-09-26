class Routine < ActiveRecord::Base

  belongs_to :trainer, :class_name => 'User', :foreign_key => 'trainer_id'
  belongs_to :client, :class_name => 'User', :foreign_key => 'client_id'
 
  has_many :activities, :through => :activity_sets
  has_many :measurements, :through => :activity_sets
  has_many :activity_sets, :order => :position

  validates_presence_of :name
  validates_presence_of :goal
  validates_uniqueness_of :name, :scope => :client_id

  before_save { self.permalink = name.to_identifier}

  def to_param
    permalink
  end

end
