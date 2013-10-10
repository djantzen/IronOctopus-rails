class Activity < ActiveRecord::Base  

  belongs_to :activity_type
  has_and_belongs_to_many :metrics
  has_many :units, :through => :metrics
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  has_many :measurements, :through => :activity_sets
  has_many :routines, :through => :activity_sets
  has_many :activity_sets
  has_many :activity_videos
  has_many :activity_images
  has_and_belongs_to_many :activity_attributes
  has_and_belongs_to_many :body_parts
  has_and_belongs_to_many :implements
  has_many :activity_citations

  accepts_nested_attributes_for :activity_images

  before_validation { self.permalink = name.to_identifier }
  validates_uniqueness_of :permalink

  VALIDATIONS = IronOctopus::Configuration.instance.validations[:activity]
  validates :name, :length => {
    :minimum => VALIDATIONS[:name][:minlength].to_i,
    :maximum => VALIDATIONS[:name][:maxlength].to_i
  }
  validates :instructions, :length => {
    :minimum => VALIDATIONS[:instructions][:minlength].to_i,
    :maximum => VALIDATIONS[:instructions][:maxlength].to_i
  }

  def to_param
    permalink
  end

  def to_s
    name
  end

end
