class Activity < ActiveRecord::Base  

  belongs_to :activity_type
  has_and_belongs_to_many :metrics
  has_many :units, :through => :metrics
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  has_many :measurements, :through => :activity_sets
  has_many :routines, :through => :activity_sets
  has_many :activity_sets
  has_and_belongs_to_many :activity_attributes
  has_and_belongs_to_many :body_parts
  has_and_belongs_to_many :implements

  validates_presence_of :name
  validates_uniqueness_of :name

  before_save { self.permalink = name.to_identifier }

  def to_param
    permalink
  end

  def to_s
    name
  end

end
