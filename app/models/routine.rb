class Routine < ActiveRecord::Base

  belongs_to :trainer, :class_name => 'User', :foreign_key => :trainer_id
  belongs_to :client, :class_name => 'User', :foreign_key => :client_id
 
  has_many :activities, :through => :activity_sets
  has_many :measurements, :through => :activity_sets
  has_many :activity_sets, :order => :position

  has_many :weekday_programs
  has_many :scheduled_programs

  VALIDATIONS = IronOctopus::Configuration.instance.validations[:routine]
  validates :name, :length => {
    :minimum => VALIDATIONS[:name][:minlength].to_i,
    :maximum => VALIDATIONS[:name][:maxlength].to_i
  }
  validates :goal, :length => {
    :minimum => VALIDATIONS[:goal][:minlength].to_i,
    :maximum => VALIDATIONS[:goal][:maxlength].to_i
  }

  validates_uniqueness_of :name, :scope => :client_id

  before_validation { self.permalink = name.to_identifier }

  def to_param
    permalink
  end

  def to_s
    name
  end
end
