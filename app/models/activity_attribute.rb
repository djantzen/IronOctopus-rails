class ActivityAttribute < ActiveRecord::Base

  has_and_belongs_to_many :activities
  has_many :activity_type, :through => :activity

  validates_presence_of :name, :on => :save

  before_save { self.permalink = name.to_identifier }

  def self.facets
    ActivityAttribute.select("activity_attributes.name, count(activities.activity_id)")
                     .joins("left join activities_activity_attributes using(activity_attribute_id)")
                     .joins("left join activities using(activity_id)")
                     .group("activity_attributes.name")
                     .order("activity_attributes.name")
  end

  def to_param
    permalink
  end

  def to_s
    name
  end

end
