class ActivityAttribute < ActiveRecord::Base

  has_and_belongs_to_many :activities
  has_many :activity_type, :through => :activity

  validates_presence_of :name, :on => [:create, :update]

  before_save { self.permalink = name.to_identifier }

  def to_param
    permalink
  end

  def to_s
    name
  end

end
